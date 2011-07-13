require 'ext/melbourne'
require 'melbourne/parser'
require 'melbourne/processor'

module Melbourne
end

class String

  # Creates an AST for a +String+ containing Ruby source code.
  #
  # @param [String] name+
  #   the name of the source (this is usuall the name of the file the code was read from); defaults to +(eval)+
  # @param [Fixnum] line
  #   the starting line (if it's not 1 for some reason); defaults to +1+
  #
  # @example Converting Ruby code in a string to an AST
  #
  #   'class Test; end'.to_ast # => <AST::Class:0x1017800f8...
  #
  def to_ast(name = '(eval)', line = 1)
    Melbourne::Parser.parse_string(self, name, line)
  end
  
  def to_sexp(name="(eval)", line=1)
    to_ast(name, line).to_sexp
  end

end

class File

  # Creates an AST for Ruby source code read from a file.
  #
  # @param [String] name
  #   the name of the file to read the source code from.
  # @param [Fixnum] line
  #   the starting line (if it's not 1 for some reason); defaults to +1+
  #
  # @example Converting Ruby code from a file to an AST
  #
  #   File.to_ast('user.rb') # => <AST::Class:0x1017800f8...
  #
  def self.to_ast(name, line = 1)
    Melbourne::Parser.parse_file(name, line)
  end

  def self.to_sexp(name, line=1)
    to_ast(name, line).to_sexp
  end

end
