require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "X::Y"' do
    ruby = 'X::Y'
    ast  = {:constaccess=>
      {:@parent=>{:constfind=>{:@name=>:X, :@line=>1}}, :@name=>:Y, :@line=>1}}

    ruby.should parse_as(ast)
  end

end
