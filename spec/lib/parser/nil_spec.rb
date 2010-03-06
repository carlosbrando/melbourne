require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "nil"' do
    ruby = 'nil'
    # Melbourne::AST::ReducedGraph doesn't explicitely return data for nil nodes
    ast  = {}

    ruby.should parse_as(ast)
  end

end
