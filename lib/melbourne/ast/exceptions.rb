module Melbourne

  module AST

    # A +begin+ statement as in:
    #
    #   begin
    #     do
    #   rescue
    #     puts 'error'
    #   end
    #
    class Begin < Node

      # The +rescue+ statement to the +begin+ statement id there is any
      #
      attr_accessor :rescue

      def initialize(line, body)
        @line = line
        @rescue = body
      end

    end

    EnsureType = 1

    # An +ensure+ statement as in:
    #
    #   begin
    #     do
    #   rescue
    #     puts 'error'
    #   ensure
    #     clean
    #   end
    #
    class Ensure < Node

      # The body of the +ensure+ statement
      #
      attr_accessor :body

      # A literal if one is defined as the only statement in the +ensure+ statement
      #
      attr_accessor :ensure

      def initialize(line, body, ensr)
        @line = line
        @body = body || Nil.new(line)
        @ensure = ensr
      end

    end

    RescueType = 0

    # A +rescue+ statement as in:
    #
    #   begin
    #     do
    #   rescue
    #     puts 'error'
    #   end
    #
    class Rescue < Node

      # The body of the +rescue+ block
      #
      attr_accessor :body

      # The exception or other element that is rescued from
      #
      attr_accessor :rescue

      # The +else+ block of the +rescue+ block (+else+ is an alias for +ensure+ here)
      #
      attr_accessor :else

      def initialize(line, body, rescue_body, else_body)
        @line = line
        @body = body
        @rescue = rescue_body
        @else = else_body
      end

    end

    # A +rescue+ condition as in:
    #
    #   begin
    #     do
    #   rescue RuntimeError => e
    #     puts 'error'
    #   end
    #
    class RescueCondition < Node

      # The actual conditions of rescue condition
      #
      attr_accessor :conditions

      # Assignments in the rescue condition (e.g. +RuntimeError => e+, where +e+ is assigned)
      #
      attr_accessor :assignment

      # The body os the +rescue+ block
      #
      attr_accessor :body

      # TODO: document!
      attr_accessor :next

      # TODO: document!
      attr_accessor :splat

      def initialize(line, conditions, body, nxt)
        @line = line
        @next = nxt
        @splat = nil
        @assignment = nil

        case conditions
        when ArrayLiteral
          @conditions = conditions
        when ConcatArgs
          @conditions = conditions.array
          @splat = RescueSplat.new line, conditions.rest
        when SplatValue
          @splat = RescueSplat.new line, conditions.value
        when nil
          condition = ConstFind.new line, :StandardError
          @conditions = ArrayLiteral.new line, [condition]
        end

        case body
        when Block
          @assignment = body.array.shift if assignment? body.array.first
          @body = body
        when nil
          @body = Nil.new line
        else
          if assignment? body
            @assignment = body
            @body = Nil.new line
          else
            @body = body
          end
        end
      end

      # TODO: document!
      def assignment?(node)
        case node
        when VariableAssignment
          value = node.value
        when AttributeAssignment
          value = node.arguments.array.last
        else
          return false
        end

        return true if value.kind_of? GlobalVariableAccess and value.name == :$!
      end

    end

    # TODO: document!
    class RescueSplat < Node

      attr_accessor :value

      def initialize(line, value)
        @line = line
        @value = value
      end

    end

  end

end
