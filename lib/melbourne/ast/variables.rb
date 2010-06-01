module Melbourne

  module AST

    # A back reference as in:
    #
    #   $&
    #
    # or
    #
    #   $'
    #
    class BackRef < Node

      # The kind of back reference
      #
      attr_accessor :kind

      def initialize(line, ref)
        @line = line
        @kind = ref
      end

    end

    # A reference to the nth match in a regular expression match result as in:
    #
    #   $1
    #
    class NthRef < Node

      # The number of the match that is referenced
      #
      attr_accessor :which

      def initialize(line, ref)
        @line = line
        @which = ref
      end

    end

    class VariableAccess < Node

      attr_accessor :name

      def initialize(line, name)
        @line = line
        @name = name
      end

    end

    class VariableAssignment < Node

      attr_accessor :name, :value

      def initialize(line, name, value)
        @line = line
        @name = name
        @value = value
      end

    end

    # Access of a class variable as in:
    #
    #   puts @@var
    #
    class ClassVariableAccess < VariableAccess

    end

    # An assignment to a class variable as in:
    #
    #   @@var = 1
    #
    class ClassVariableAssignment < VariableAssignment

    end

    class CVarDeclare < ClassVariableAssignment

    end

    # Access of a global variable as in:
    #
    #   $stderr
    #
    class GlobalVariableAccess < VariableAccess

    end

    # Assignment to a global variable as in:
    #
    #   $x = 1
    #
    class GlobalVariableAssignment < VariableAssignment

    end

    # Assignment to a splat (+*some+) as in:
    #
    #   *c = *[1, 2]
    #
    class SplatAssignment < Node

      # The value being assigned to the splat
      #
      attr_accessor :value

      def initialize(line, value)
        @line = line
        @value = value
      end

    end

    class SplatArray < SplatAssignment

      def initialize(line, value, size)
        @line = line
        @value = value
        @size = size
      end

    end

    class SplatWrapped < SplatAssignment

    end

    # An empty splat as in:
    #
    #   * = 1, 2
    #
    class EmptySplat < Node

      def initialize(line, size)
        @line = line
        @size = size
      end

    end

    # Access of an instance variable as in:
    #
    #   puts @var
    #
    class InstanceVariableAccess < VariableAccess

    end

    # An assignment to an instance variable as in:
    #
    #   @var = 1
    #
    class InstanceVariableAssignment < VariableAssignment

    end

    # Access of a local variable as in:
    #
    #   puts var
    #
    class LocalVariableAccess < VariableAccess

      include LocalVariable

      def initialize(line, name)
        @line = line
        @name = name
        @variable = nil
      end

    end

    # An assignment to an instance variable as in:
    #
    #   var = 1
    #
    class LocalVariableAssignment < VariableAssignment

      include LocalVariable

      def initialize(line, name, value)
        @line = line
        @name = name
        @value = value
        @variable = nil
      end

    end

    # An assignment of multiple values as in:
    #
    #   a, b = 1, 2
    #
    class MAsgn < Node

      # The left side of the assignment
      #
      attr_accessor :left

      # The right side of the assignment
      #
      attr_accessor :right

      # TODO: document!
      attr_accessor :splat

      # TODO: document!
      attr_accessor :block

      def initialize(line, left, right, splat)
        @line = line
        @left = left
        @right = right
        @splat = nil
        @block = nil # support for |&b|

        @fixed = right.kind_of?(ArrayLiteral) ? true : false

        if splat.kind_of? Node
          if @left
            if right
              @splat = SplatAssignment.new line, splat
            else
              @splat = SplatWrapped.new line, splat
            end
          elsif @fixed
            @splat = SplatArray.new line, splat, right.body.size
          elsif right.kind_of? SplatValue
            @splat = splat
          else
            @splat = SplatWrapped.new line, splat
          end
        elsif splat and @fixed
          @splat = EmptySplat.new line, right.body.size
        end
      end

      def iter_arguments
        @iter_arguments = true
      end

    end

  end

end
