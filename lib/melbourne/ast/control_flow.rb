module Melbourne

  module AST

    # A +case+ statement as in
    #
    #   case
    #     when a == 1 then
    #       # something
    #     when a == 2
    #       # something
    #   end
    #
    class Case < Node

      # The +when+ nodes of the +case+ statement
      #
      attr_accessor :whens

      # The +else+ node of the +case+ statement (or +nil+ if there is none)
      #
      attr_accessor :else

      def initialize(line, whens, else_body)
        @line = line
        @whens = whens
        @else = else_body || Nil.new(line)
      end

    end

    # A +case+ statement with a receiver as in:
    #
    #   case a
    #     when 1 then
    #       # something
    #     when 2
    #       # something
    #   end
    #
    class ReceiverCase < Case

      # The receiver of the +case+ statement
      #
      attr_accessor :receiver

      def initialize(line, receiver, whens, else_body)
        @line = line
        @receiver = receiver
        @whens = whens
        @else = else_body || Nil.new(line)
      end

    end

    # A +when+ statement in a +case+ statement as in:
    #
    #   case a
    #     when 1 then
    #       # something
    #     when 2
    #       # something
    #   end
    #
    class When < Node

      # The conditions for which the +when+ statement is true or +nil+ if only a single value is specified
      #
      attr_accessor :conditions

      # The body for the +when+ statement
      #
      attr_accessor :body

      # The single value for the +when+ statement if only a single value is specified, +nil+ otherwise
      #
      attr_accessor :single

      # Any splat (+*something+) that is specified as a condition for the +when+ statement or +nil+ of no splat is specified
      #
      attr_accessor :splat

      def initialize(line, conditions, body)
        @line = line
        @body = body || Nil.new(line)
        @splat = nil
        @single = nil

        if conditions.kind_of? ArrayLiteral
          if conditions.body.last.kind_of? When
            last = conditions.body.pop
            if last.conditions.kind_of? ArrayLiteral
              conditions.body.concat last.conditions.body
            elsif last.single
              @splat = SplatWhen.new line, last.single
            else
              @splat = SplatWhen.new line, last.conditions
            end
          end

          if conditions.body.size == 1 and !@splat
            @single = conditions.body.first
          else
            @conditions = conditions
          end
        else
          @conditions = conditions
        end
      end

    end

    # A splat (+*something+) inside a condition of a +when+ statement as in:
    #
    #   case a
    #     when *c then
    #       d
    #   end
    #
    class SplatWhen < Node

      # The actual content of the plat
      #
      attr_accessor :condition

      def initialize(line, condition)
        @line = line
        @condition = condition
      end

    end

    # A flip statement as in:
    #
    #   1 if TRUE..FALSE
    #
    class Flip2 < Node

      def initialize(line, start, finish)
        @line = line
        @start = start
        @finish = finish
      end

    end

    # An end-exclusive flip statement as in:
    #
    #   1 if TRUE...FALSE
    #
    class Flip3 < Node

      def initialize(line, start, finish)
        @line = line
        @start = start
        @finish = finish
      end

    end

    # An +if+ statement as in:
    #
    #   a if true
    #
    class If < Node

      # The condition of the +if+ statement
      #
      attr_accessor :condition

      # The body of the +if+ statement (the code that is executed if the +condition+ evaluates to true)
      #
      attr_accessor :body

      # The +else+ block of the +if+ statement (if there is one)
      #
      attr_accessor :else

      def initialize(line, condition, body, else_body)
        @line = line
        @condition = condition
        @body = body || Nil.new(line)
        @else = else_body || Nil.new(line)
      end

    end

    # A +while+ statement as in:
    #
    #   i += 1 while go_on?
    #
    class While < Node

      # The condition of the +while+ statement
      #
      attr_accessor :condition

      # The body of the +while+ statement (the code that is executed if the +condition+ evaluates to true)
      #
      attr_accessor :body

      # Whether to check the +while+ statement's condition before or after ths code in the +body+ is executed
      #
      attr_accessor :check_first

      def initialize(line, condition, body, check_first)
        @line = line
        @condition = condition
        @body = body || Nil.new(line)
        @check_first = check_first
      end

    end

    # An +until+ statement as in:
    #
    #   i += 1 until stop?
    #
    class Until < While

    end

    # A regular expression match statement as in:
    #
    #   x =~ /x/
    #
    class Match < Node

      # the regex pattern used for the match
      #
      attr_accessor :pattern

      def initialize(line, pattern, flags)
        @line = line
        @pattern = RegexLiteral.new line, pattern, flags
      end

    end

    # A regular expression match statement with the regular expression pattern as the receiver as in:
    #
    #   /x/ =~ x
    #
    class Match2 < Node

      # the regex pattern used for the match
      #
      attr_accessor :pattern

      # the value that is matched against the +pattern+
      #
      attr_accessor :value

      def initialize(line, pattern, value)
        @line = line
        @pattern = pattern
        @value = value
      end

    end

    # A regular expression match statement where a String is matched against the pattern as in:
    #
    #   'some' =~ /x/
    #
    class Match3 < Node

      # the regex pattern used for the match
      #
      attr_accessor :pattern

      # the value that is matched against the +pattern+
      #
      attr_accessor :value

      def initialize(line, pattern, value)
        @line = line
        @pattern = pattern
        @value = value
      end

    end

    # A +break+ statement as in:
    #
    #   while true do
    #     begin
    #       x
    #     rescue Exception => x
    #       break
    #     end
    #   end
    #
    class Break < Node

      # The value passed to +break+
      #
      attr_accessor :value

      def initialize(line, expr)
        @line = line
        @value = expr || Nil.new(line)
      end

    end

    # A +next+ statement as in:
    #
    #   while true do
    #     next if skip?(i)
    #     i += 1
    #   end
    #
    class Next < Break

      def initialize(line, value)
        @line = line
        @value = value
      end

    end

    # A +redo+ statement as in:
    #
    #   while true do
    #     begin
    #       x
    #     rescue Exception => x
    #       redo
    #     end
    #   end
    #
    class Redo < Break

      def initialize(line)
        @line = line
      end

    end

    # A +redo+ statement as in:
    #
    #   while true do
    #     begin
    #       x
    #     rescue Exception => x
    #       try_to_fix()
    #       retry
    #     end
    #   end
    #
    class Retry < Break

      def initialize(line)
        @line = line
      end

    end

    # A +return+ statement as in:
    #
    #   def method
    #     return 3
    #   end
    #
    class Return < Node

      # The value passed to +return+
      #
      attr_accessor :value

      def initialize(line, expr)
        @line = line
        @value = expr
        @splat = nil
      end

    end

  end

end
