module Melbourne

  module AST

    # A method invocation (a message being sent) as in:
    #
    #   method()
    #
    class Send < Node

      # The receiver of the message/ invocation
      #
      attr_accessor :receiver

      # The message being sent/ method being invoked
      #
      attr_accessor :name

      attr_accessor :privately #:nodoc:

      # The block that is passed to the invocation if one is passed
      #
      attr_accessor :block

      attr_accessor :variable #:nodoc:

      attr_accessor :check_for_local #:nodoc:

      def initialize(line, receiver, name, privately=false) #:nodoc:
        @line = line
        @receiver = receiver
        @name = name
        @privately = privately
        @block = nil
        @check_for_local = false
      end

    end

    # A method invocation (a message being sent) where arguments are passed as in:
    #
    #   method(a, b)
    #
    class SendWithArguments < Send

      # The arguments that are passed
      #
      attr_accessor :arguments

      def initialize(line, receiver, name, arguments, privately=false) #:nodoc:
        super line, receiver, name, privately
        @block = nil
        @arguments = ActualArguments.new line, arguments
      end

    end

    # An attribute assignment as in:
    #
    #   object.attribute = 1
    #
    class AttributeAssignment < SendWithArguments

      def initialize(line, receiver, name, arguments) #:nodoc:
        @line = line

        @receiver = receiver
        @privately = receiver.kind_of?(Self) ? true : false

        @name = :"#{name}="

        @arguments = ActualArguments.new line, arguments
      end

    end

    # An element assignment as in:
    #
    #   a[0] = 1
    #
    class ElementAssignment < SendWithArguments

      def initialize(line, receiver, arguments) #:nodoc:
        @line = line

        @receiver = receiver
        @privately = receiver.kind_of?(Self) ? true : false

        @name = :[]=

        case arguments
        when PushArgs
          @arguments = arguments
        else
          @arguments = ActualArguments.new line, arguments
        end
      end

    end

    # Arguments of element assignment as in:
    #
    #   a[0] = 1 # 1 is the push argument
    #
    class PushArgs < Node

      # The actual value of the argument
      #
      attr_accessor :value

      # The arguments used to access the element the push argument is assigned to
      #
      attr_accessor :arguments

      def initialize(line, arguments, value) #:nodoc:
        @line = line
        @arguments = arguments
        @value = value
      end

      # Gets the number of push arguments
      #
      # === Example:
      #
      #   a[0] = 1 # size is 1
      #
      def size
        splat? ? 1 : @arguments.size + 1
      end

      # Gets whether the push arguments are a splat (<tt>*some</tt>)
      #
      # === Example:
      #
      #   a[0] = *b # the push arguments are a splat here
      #
      def splat?
        @arguments.kind_of? SplatValue
      end

    end

    # A block that is passed as a parameter as in:
    #
    #   method(&b)
    #
    class BlockPass < Node

      # The actual block that is passed
      #
      attr_accessor :body

      def initialize(line, body) #:nodoc:
        @line = line
        @body = body
      end

    end

    # The actual arguments that are passed to a method as in:
    #
    #   method(1, b) # the actual arguments are a and b
    #
    class ActualArguments < Node

      # The array of arguments
      #
      attr_accessor :array

      # A splat (<tt>*some</tt>) if the actual arguments contain one
      #
      attr_accessor :splat

      def initialize(line, arguments=nil) #:nodoc:
        @line = line
        @splat = nil

        case arguments
        when SplatValue
          @splat = arguments
          @array = []
        when ConcatArgs
          @array = arguments.array.body
          @splat = SplatValue.new line, arguments.rest
        when ArrayLiteral
          @array = arguments.body
        when nil
          @array = []
        else
          @array = [arguments]
        end
      end

      # Gets the number of actual arguments.
      #
      # === Example
      #
      #   method(1, b) # the number of actual arguments is 2
      #
      def size
        @array.size
      end

      # Gets whether the actual arguments contain a splat.
      #
      # === Example
      #
      #   method(*b) # splat? is true
      #
      def splat?
        not @splat.nil?
      end

    end

    # A code block as in:
    #
    #   m { some }
    #
    class Iter < Node

      # The parent node of the code block
      #
      attr_accessor :parent

      # The arguments of the code block
      #
      attr_accessor :arguments

      # The body of the code block
      #
      attr_accessor :body

      def initialize(line, arguments, body) #:nodoc:
        @line = line
        @arguments = IterArguments.new line, arguments
        @body = body || Nil.new(line)
      end

    end

    # Arguments of a code block as in:
    #
    #   m { |arg| some }
    #
    class IterArguments < Node

      # TODO: document!
      attr_accessor :prelude #:nodoc:

      # The number of arguments
      #
      attr_accessor :arity

      # The optional arguments
      #
      attr_accessor :optional

      # The actual array of arguments
      #
      attr_accessor :arguments

      # TODO: document!
      attr_accessor :splat_index #:nodoc:

      # The required arguments
      #
      attr_accessor :required_args

      def initialize(line, arguments) #:nodoc:
        @line = line
        @optional = 0

        @splat_index = -1
        @required_args = 0
        @splat = nil
        @block = nil

        array = []
        case arguments
        when Fixnum
          @arity = 0
          @prelude = nil
        when MAsgn
          arguments.iter_arguments

          if arguments.splat
            @splat = arguments.splat = arguments.splat.value

            @optional = 1
            if arguments.left
              @prelude = :multi
              @arity = -(arguments.left.body.size + 1)
              @required_args = arguments.left.body.size
            else
              @prelude = :splat
              @arity = -1
            end
          elsif arguments.left
            @prelude = :multi
            @arity = arguments.left.body.size
            @required_args = arguments.left.body.size
          else
            @prelude = :multi
            @arity = -1
          end

          @block = arguments.block

          @arguments = arguments
        when nil
          @arity = -1
          @splat_index = -2 # -2 means accept the splat, but don't store it anywhere
          @prelude = nil
        when BlockPass
          @arity = -1
          @splat_index = -2
          @prelude = nil
          @block = arguments
        else # Assignment
          @arguments = arguments
          @arity = 1
          @required_args = 1
          @prelude = :single
        end
      end

      alias_method :total_args, :required_args

      # TODO: document!
      def names #:nodoc:
        case @arguments
        when MAsgn
          if arguments = @arguments.left.body
            array = arguments.map { |x| x.name }
          else
            array = []
          end

          if @arguments.splat.kind_of? SplatAssignment
            array << @arguments.splat.name
          end

          array
        when nil
          []
        else
          [@arguments.name]
        end
      end

    end

    # A +for+ statement as in:
    #
    #   for o in ary do
    #     puts(o)
    #   end
    #
    class For < Iter

    end

    # A negation as in:
    #
    #   -1
    #
    class Negate < Node

      # The value that is negated
      #
      attr_accessor :value

      def initialize(line, value) #:nodoc:
        @line = line
        @value = value
      end

    end

    # A +super+ statement as in:
    #
    #   def method
    #     super
    #   end
    #
    class Super < SendWithArguments

      # The name of the node
      #
      attr_accessor :name

      # A block that is passed to <tt>super()</tt> if one is passed
      #
      attr_accessor :block

      def initialize(line, arguments) #:nodoc:
        @line = line
        @block = nil
        @arguments = ActualArguments.new line, arguments
      end

    end

    # A +yield+ statement as in:
    #
    #   def method(&block)
    #     yield 1
    #   end
    #
    class Yield < SendWithArguments

      # TODO: document!
      attr_accessor :flags #:nodoc:

      def initialize(line, arguments, unwrap) #:nodoc:
        @line = line

        if arguments.kind_of? ArrayLiteral and not unwrap
          arguments = ArrayLiteral.new line, [arguments]
        end

        @arguments = ActualArguments.new line, arguments
        @argument_count = @arguments.size
        @yield_splat = false

        if @arguments.splat?
          splat = @arguments.splat.value
          if (splat.kind_of? ArrayLiteral or splat.kind_of? EmptyArray) and not unwrap
            @argument_count += 1
          else
            @yield_splat = true
          end
        end
      end

    end

    # TODO: document!
    class ZSuper < Super #:nodoc:

      def initialize(line)
        @line = line
        @block = nil
      end

    end

  end

end
