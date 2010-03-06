module Melbourne

  module AST

    # TODO: document!
    class EndData < Node #:nodoc:

      attr_accessor :data

      def initialize(line, data)
        @line = line
        @data = data
      end

    end

  end

end
