module Melbourne

  module AST

    # An +alias+ statement as in:
    #
    #   alias x y
    #
    class Alias < Node

      # The element that is aliased
      #
      attr_accessor :to

      # The alias that is defined for the element
      #
      attr_accessor :from

      def initialize(line, to, from) #:nodoc:
        @line = line
        @to = to
        @from = from
      end

    end

    # TODO: document!
    class VAlias < Alias #:nodoc:

    end

    # An +undef+ statement as in:
    #
    #   undef :x
    #
    class Undef < Node

      # The name of the +undef+'d element
      #
      attr_accessor :name

      def initialize(line, sym) #:nodoc:
        @line = line
        @name = sym
      end

    end

    # A code block as in:
    #
    #   begin
    #   end
    #
    # but also as in (implicit block):
    #
    #   a = 1; b = 2
    #
    class Block < Node

      # The statements inside of the block
      #
      attr_accessor :array

      def initialize(line, array) #:nodoc:
        @line = line
        @array = array
      end

      # TODO: document!
      def strip_arguments #:nodoc:
        if @array.first.kind_of? FormalArguments
          node = @array.shift
          if @array.first.kind_of? BlockArgument
            node.block_arg = @array.shift
          end
          return node
        end
      end

    end

    # TODO: document!
    class ClosedScope < Node #:nodoc:

      attr_accessor :body

    end

    # A method definition as in:
    #
    #   def method
    #   end
    #
    class Define < ClosedScope

      # The name of the defined method
      #
      attr_accessor :name

      # The arguments of the defined method
      #
      attr_accessor :arguments

      def initialize(line, name, block) #:nodoc:
        @line = line
        @name = name
        @arguments = block.strip_arguments
        block.array << Nil.new(line) if block.array.empty?
        @body = block
      end

    end

    # A singleton method definition as in:
    #
    #   def object.method
    #   end
    #
    class DefineSingleton < Node

      # The receiver of the definition
      #
      attr_accessor :name

      # The body of the defined method
      #
      attr_accessor :body

      def initialize(line, receiver, name, block) #:nodoc:
        @line = line
        @receiver = receiver
        @body = DefineSingletonScope.new line, name, block
      end

    end

    # The scope a singletion method definition opens. This is the actual body of +Melbourne::AST::DefineSingleton+s
    #
    class DefineSingletonScope < Define

      def initialize(line, name, block) #:nodoc:
        super line, name, block
      end

    end

    # The formal arguments of a method definition as in:
    #
    #   def method(x) # x is a formal argument of the method
    #   end
    #
    class FormalArguments < Node

      # The names of the arguments
      #
      attr_accessor :names

      # The names of the required arguments
      #
      attr_accessor :required

      # The names of the optional arguments
      #
      attr_accessor :optional

      # The arguments of the method that have default values
      #
      attr_accessor :defaults

      # The splat (<tt>*some</tt>) arguments of the method
      #
      attr_accessor :splat

      # The block argument if there is one
      #
      attr_accessor :block_arg

      def initialize(line, args, defaults, splat) #:nodoc:
        @line = line
        @defaults = nil
        @block_arg = nil

        if defaults
          defaults = DefaultArguments.new line, defaults
          @defaults = defaults
          @optional = defaults.names

          stop = defaults.names.first
          last = args.each_with_index { |a, i| break i if a == stop }
          @required = args[0, last]
        else
          @required = args.dup
          @optional = []
        end

        if splat.kind_of? Symbol
          args << splat
        elsif splat
          splat = :@unnamed_splat
          args << splat
        end
        @names = args
        @splat = splat
      end

      def block_arg=(node) #:nodoc:
        @names << node.name
        @block_arg = node
      end

      # Gets the arity of the method. The arity is the number of required arguments the method defines.
      #
      # === Example
      #
      #   def method(a, b = 1) # arity is 1 as the second argument is optional
      #   end
      #
      def arity
        @required.size
      end

      # Gets the number of required arguments the method defines.
      #
      def required_args
        @required.size
      end

      # Gets the total number of all arguments the method defines.
      #
      def total_args
        @required.size + @optional.size
      end

      # TODO: document!
      def splat_index #:nodoc:
        if @splat
          index = @names.size
          index -= 1 if @block_arg
          index -= 1 if @splat.kind_of? Symbol
          index
        end
      end

    end

    # Defaults arguments of a method. This of node also contains the actual statements that define the defaults.
    #
    class DefaultArguments < Node

      # The statements that define the defaults (these are usually Melbourne::AST::LocalVariableAssignment nodes)
      #
      attr_accessor :arguments

      # The names of the arguments
      #
      attr_accessor :names

      def initialize(line, block) #:nodoc:
        @line = line
        array = block.array
        @names = array.map { |a| a.name }
        @arguments = array
      end

    end

    module LocalVariable #:nodoc:

      attr_accessor :variable

    end

    # A block argument as in:
    #
    #   def method(&block)
    #   end
    #
    class BlockArgument < Node

      include LocalVariable

      # The name of the block argument
      #
      attr_accessor :name

      def initialize(line, name) #:nodoc:
        @line = line
        @name = name
      end

    end

    # A class as in:
    #
    #   class X; end
    #
    class Class < Node

      # The name of the +class+
      #
      attr_accessor :name

      # The superclass of the +class+
      #
      attr_accessor :superclass

      # The body of the +class+
      #
      attr_accessor :body

      def initialize(line, name, superclass, body) #:nodoc:
        @line = line

        @superclass = superclass ? superclass : Nil.new(line)

        if name.kind_of? Symbol
          @name = ClassName.new line, name, @superclass
        else
          @name = ScopedClassName.new line, name, @superclass
        end

        if body
          @body = ClassScope.new line, @name, body
        else
          @body = EmptyBody.new line
        end
      end

    end

    # The scope a class definition opens. This is the actual body of +Melbourne::AST::Class+es
    #
    class ClassScope < ClosedScope

      def initialize(line, name, body) #:nodoc:
        @line = line
        @name = name.name
        @body = body
      end

    end

    # A class name as in:
    #
    #   class X; end
    #
    class ClassName < Node

      # The actual name of the class
      #
      attr_accessor :name

      # TODO: document!
      attr_accessor :superclass #:nodoc:

      def initialize(line, name, superclass) #:nodoc:
        @line = line
        @name = name
        @superclass = superclass
      end

    end

    # A scoped class name as in:
    #
    #   class X::Y; end
    #
    class ScopedClassName < ClassName

      # The parent of the scoped class name; for a class <tt>class X::Y; end</tt> the scoped class name is +Y+ and the parent is +X+
      #
      attr_accessor :parent

      def initialize(line, parent, superclass) #:nodoc:
        @line = line
        @name = parent.name
        @parent = parent.parent
        @superclass = superclass
      end

    end

    # A module as in:
    #
    #   module M; end
    #
    class Module < Node

      # The name of the module
      #
      attr_accessor :name

      # The body of the module
      #
      attr_accessor :body

      def initialize(line, name, body) #:nodoc:
        @line = line

        if name.kind_of? Symbol
          @name = ModuleName.new line, name
        else
          @name = ScopedModuleName.new line, name
        end

        if body
          @body = ModuleScope.new line, @name, body
        else
          @body = EmptyBody.new line
        end
      end

    end

    # The body of a class that has no body as in:
    #
    #   class X; end
    #
    class EmptyBody < Node

    end

    # The name of a module
    #
    class ModuleName < Node

      # The actual name of the module
      #
      attr_accessor :name

      def initialize(line, name) #:nodoc:
        @line = line
        @name = name
      end

    end

    # A scoped module name as in:
    #
    #   module X::M; end
    #
    class ScopedModuleName < ModuleName

      # The parent of the scoped module name; for a module <tt>module X::M; end</tt> the scoped module name is +Y+ and the parent is +X+
      #
      attr_accessor :parent

      def initialize(line, parent) #:nodoc:
        @line = line
        @name = parent.name
        @parent = parent.parent
      end

    end

    # The scope a module definition opens. This is the actual body of +Melbourne::AST::Module+s
    #
    class ModuleScope < ClosedScope

      def initialize(line, name, body) #:nodoc:
        @line = line
        @name = name.name
        @body = body
      end

    end

    # A singleton class as in:
    #
    #   class X
    #     class << self
    #     end
    #   end
    #
    class SClass < Node

      # The receiver (for <tt>class << self</tt>, +self+ is the receiver)
      #
      attr_accessor :receiver

      def initialize(line, receiver, body) #:nodoc:
        @line = line
        @receiver = receiver
        @body = SClassScope.new line, body
      end

    end

    # The scope a singleton class definition opens. This is the actual body of +Melbourne::AST::SClass+s
    #
    class SClassScope < ClosedScope

      def initialize(line, body) #:nodoc:
        @line = line
        @body = body
        @name = nil
      end

    end

    # TODO: document!
    class Container < ClosedScope #:nodoc:

      attr_accessor :file, :name, :variable_scope

      def initialize(body)
        @body = body || Nil.new(1)
      end

    end

    # TODO: document!
    class EvalExpression < Container #:nodoc:

      def initialize(body)
        super body
        @name = :__eval_script__
      end

    end

    # TODO: document!
    class Snippit < Container #:nodoc:

      def initialize(body)
        super body
        @name = :__snippit__
      end

    end

    # TODO: document!
    class Script < Container #:nodoc:

      def initialize(body)
        super body
        @name = :__script__
      end

    end

    # A <tt>defined?</tt> statement as in:
    #
    #   defined? a
    #
    class Defined < Node

      # The expression passed to <tt>defined?</tt>
      #
      attr_accessor :expression

      def initialize(line, expr) #:nodoc:
        @line = line
        @expression = expr
      end

    end

  end

end
