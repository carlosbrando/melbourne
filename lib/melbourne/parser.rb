module Melbourne

  class Parser

    def self.parse_string(string, name = '(eval)', line = 1)
      new(name, line).parse_string(string)
    end

    def self.parse_file(name, line=1)
      new(name, line).parse_file
    end

    def initialize(name, line, transforms=[])
      @name = name
      @line = line > 0 ? line : 1
    end

    def syntax_error
      raise @exc if @exc
    end

    def parse_string(string)
      syntax_error unless ast = string_to_ast(string, @name, @line)
      ast
    end

    def parse_file
      unless @name and File.exists?(@name)
        raise Errno::ENOENT, @name.inspect
      end
      
      syntax_error unless ast = file_to_ast(@name, @line)
      ast
    end

  end

end