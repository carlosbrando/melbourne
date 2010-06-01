module Melbourne

  module AST

    # The +and+ operator as in:
    #
    #   a and b
    #
    class And < Node

      # The left-side expression of the +and+ operator
      #
      attr_accessor :left

      # The right-side expression of the +and+ operator
      #
      attr_accessor :right

      def initialize(line, left, right)
        @line = line
        @left = left
        @right = right
      end

    end

    # The +or+ operator as in:
    #
    #   a or b
    #
    class Or < And

    end

    # The +not+ operator as in:
    #
    #   (not true)
    #
    class Not < Node

      # The value that is negated
      #
      attr_accessor :value

      def initialize(line, value)
        @line = line
        @value = value
      end

    end

    # TODO: document!
    class OpAssign1 < Node

      attr_accessor :receiver

      attr_accessor :op

      attr_accessor :index

      attr_accessor :value

      def initialize(line, receiver, index, op, value)
        @line = line
        @receiver = receiver
        @op = op
        @index = index.body
        @value = value
      end

    end

    # TODO: document!
    class OpAssign2 < Node

      attr_accessor :receiver

      attr_accessor :op

      attr_accessor :name

      attr_accessor :assign

      attr_accessor :value

      def initialize(line, receiver, name, op, value)
        @line = line
        @receiver = receiver
        @name = name
        @op = op
        @value = value
        @assign = name.to_s[-1] == ?= ? name : :"#{name}="
      end

    end

    # TODO: document!
    class OpAssignAnd < Node

      attr_accessor :left, :right

      def initialize(line, left, right)
        @line = line
        @left = left
        @right = right
      end

    end

    # TODO: document!
    class OpAssignOr < OpAssignAnd

    end

  end

end
