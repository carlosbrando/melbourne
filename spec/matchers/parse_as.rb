# The ParseAsMatcher wraps the logic for checking that a string of Ruby code
# is parsed to the expected AST.
#
class ParseAsMatcher

  def initialize(expected)
    @expected = expected
  end

  def matches?(actual)
    @actual = actual.to_ast.reduced_graph
    @actual == @expected
  end

  def failure_message
    ["Expected:\n#{@actual.inspect}\n", "to equal:\n#{@expected.inspect}"]
  end

end

class Object

  def parse_as(ast)
    ParseAsMatcher.new(ast)
  end

end
