require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "X"' do
    ruby = 'X'
    ast  = {:constfind=>{:@name=>:X, :@line=>1}}

    ruby.should parse_as(ast)
  end

end
