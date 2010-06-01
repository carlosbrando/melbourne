module Melbourne

  module AST

    # A value of a splat (+*some+) as in:
    #
    #   *1 # the value of the splat is 1
    #
    class SplatValue < Node

      # The actual value
      #
      attr_accessor :value

      def initialize(line, value)
        @line = line
        @value = value
      end

    end

    # TODO: document!
    class ConcatArgs < Node

      attr_accessor :array, :rest, :size

      def initialize(line, array, rest)
        @line = line
        @array = array
        @size = array.body.size
        @rest = rest
      end

    end

    # TODO: document!
    class SValue < Node

      attr_accessor :value

      def initialize(line, value)
        @line = line
        @value = value
      end

    end

    # TODO: document!
    class ToArray < Node

      attr_accessor :value

      def initialize(line, value)
        @line = line
        @value = value
      end

    end

    # TODO: document!
    class ToString < Node

      attr_accessor :value

      def initialize(line, value)
        @line = line
        @value = value
      end

    end

  end

end
