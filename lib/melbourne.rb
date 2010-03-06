base = File.dirname(__FILE__)

require File.join(base, 'ext/melbourne')
require File.join(base, 'melbourne/parser')
require File.join(base, 'melbourne/processor')

module Melbourne #:nodoc:
end

class String

  # Creates an AST for a +String+ containing Ruby source code.
  #
  # === Example
  #
  #   'class Test; end'.to_ast # => <AST::Class:0x1017800f8...
  #
  # === Arguments
  #
  # * +name+: the name of the source (this is usuall the name of the file the code was read from); defaults to <tt>(eval)</tt>
  # * +line+: the starting line (if it's not 1 for some reason); defaults to <tt>1</tt>
  #
  def to_ast(name = '(eval)', line = 1)
    Melbourne::Parser.parse_string(self, name, line)
  end

end

class File

  # Creates an AST for Ruby source code read from a file.
  #
  # === Example
  #
  #   File.to_ast('user.rb') # => <AST::Class:0x1017800f8...
  #
  # === Arguments
  #
  # * +name+: the name of the file to read the source code from.
  # * +line+: the starting line (if it's not 1 for some reason); defaults to <tt>1</tt>
  #
  def self.to_ast(name, line = 1)
    Melbourne::Parser.parse_file(name, line)
  end

end
