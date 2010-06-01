module Melbourne

  module AST

    # Access of a constant as in:
    #
    #   X::Y # (X is the accessed constant)
    #
    class ConstAccess < Node

      # The parent node
      #
      attr_accessor :parent

      # The name of the node
      #
      attr_accessor :name

      def initialize(line, parent, name)
        @line = line
        @parent = parent
        @name = name
      end

    end

    # A constant in the top level as in:
    #
    #   ::X
    #
    class ConstAtTop < Node

      # The parent node
      #
      attr_accessor :parent

      # The name of the node
      #
      attr_accessor :name

      def initialize(line, name)
        @line = line
        @name = name
        @parent = TopLevel.new line
      end

    end

    # The parent node of something on the lop level as in:
    #
    #   ::X # X is at the top level, it's parent is the top level itself
    #
    class TopLevel < Node

    end

    # Access of a constant within some other code node (the constant has to be found then) as in
    #
    #   def method
    #     String
    #   end
    #
    class ConstFind < Node
  
      # The name of the node
      #
      attr_accessor :name

      def initialize(line, name)
        @line = line
        @name = name
      end

    end

    # Assignment of a value to a constant as in:
    #
    #   X = 42
    #
    class ConstSet < Node

      # The parent node
      #
      attr_accessor :parent

      # The name of the node
      #
      attr_accessor :name

      # The value that is set
      #
      attr_accessor :name

      def initialize(line, name, value)
        @line = line
        @value = value
        @parent = nil

        if name.kind_of? Symbol
          @name = ConstName.new line, name
        else
          @parent = name.parent
          @name = ConstName.new line, name.name
        end
      end

    end

    # A constant's name in a constant's definition as in:
    #
    #   X = 42
    #
    class ConstName < Node

      # The name of the node
      #
      attr_accessor :name

      def initialize(line, name)
        @line = line
        @name = name
      end

    end

  end

end
