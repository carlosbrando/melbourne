module Melbourne

  module AST

    # An array literal as in:
    #
    #   [1, 2]
    #
    class ArrayLiteral < Node

      # The body os the array literal (the actual values contained in the array)
      #
      attr_accessor :body

      def initialize(line, array)
        @line = line
        @body = array
      end

    end

    # An empty array literal as in:
    #
    #   []
    #
    class EmptyArray < Node

    end

    # False as in:
    #
    #   false
    #
    class False < Node

    end

    # True as in:
    #
    #   true
    #
    class True < Node

    end

    # A float literal as in:
    #
    #   1.2
    #
    class Float < Node

      # The actual value of the float literal
      #
      attr_accessor :value

      def initialize(line, str)
        @line = line
        @value = str.to_f
      end

    end

    # An hash literal as in:
    #
    #   { :a => :b }
    #
    class HashLiteral < Node

      # The actual values in the hash literal
      #
      attr_accessor :array

      def initialize(line, array)
        @line = line
        @array = array
      end

    end

    # A symbol literal as in:
    #
    #   :x
    #
    class SymbolLiteral < Node

      # The value of the symbol literal
      #
      attr_accessor :value

      def initialize(line, sym)
        @line = line
        @value = sym
      end

    end

    # Nil as in:
    #
    #   nil
    #
    class Nil < Node

    end

    class NumberLiteral < Node

      attr_accessor :value

      def initialize(line, value)
        @line = line
        @value = value
      end

    end

    # A FixNum literal as in:
    #
    #   1
    #
    class FixnumLiteral < NumberLiteral

      def initialize(line, value)
        @line = line
        @value = value
      end

    end

    # A range literal as in:
    #
    #   1..3
    #
    class Range < Node

      # The start of the range
      #
      attr_accessor :start

      # The finish of the range
      #
      attr_accessor :finish

      def initialize(line, start, finish)
        @line = line
        @start = start
        @finish = finish
      end

    end

    # A range literal that excludes the end as in:
    #
    #   1...3
    #
    class RangeExclude < Range

      def initialize(line, start, finish)
        @line = line
        @start = start
        @finish = finish
      end

    end

    # A regular expression literal as in:
    #
    #   /.*/
    #
    class RegexLiteral < Node

      # The source of the regular expression literal
      #
      attr_accessor :source

      # Options defined for the regular expression literal (e.g. +n+ or +o+)
      #
      attr_accessor :options

      def initialize(line, str, flags)
        @line = line
        @source = str
        @options = flags
      end

    end

    # A string literal as in:
    #
    #   'some'
    #
    class StringLiteral < Node

      # The actual string of the string literal
      #
      attr_accessor :string

      def initialize(line, str)
        @line = line
        @string = str
      end

    end

    # A dynamic string literal as in:
    #
    #   "some #{a}"
    #
    class DynamicString < StringLiteral

      # The parts of the dynamic string literal
      #
      attr_accessor :array

      attr_accessor :options

      def initialize(line, str, array)
        @line = line
        @string = str
        @array = array
      end

    end

    # A dynamic symbol literal as in:
    #
    #   :"some#{a}"
    #
    class DynamicSymbol < DynamicString

    end

    # A dynamic execute string literal as in:
    #
    #   `touch #{path}`
    #
    class DynamicExecuteString < DynamicString

    end

    # A dynamic regular expression literal as in:
    #
    #   /.*#{a}/
    #
    class DynamicRegex < DynamicString

      def initialize(line, str, array, flags)
        super line, str, array
        @options = flags || 0
      end

    end

    # TODO: document!
    class DynamicOnceRegex < DynamicRegex

    end

    # An execute string literal as in:
    #
    #   `touch tmp/restart.txt`
    #
    class ExecuteString < StringLiteral

    end

  end

end
