module Melbourne

  module AST

    class Node

      def reduced_graph
        ReducedGraph.new(self).to_hash
      end

    end

  end

end
