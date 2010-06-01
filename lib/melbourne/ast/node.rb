module Melbourne

  module AST

    class Node

      attr_accessor :line

      def initialize(line)
        @line = line
      end

      def ascii_graph
        AsciiGrapher.new(self).print
      end

    end

  end

end
