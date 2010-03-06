require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "alias $y $x"' do
    ruby = 'alias $y $x'
    ast  = {:valias=>{:@line=>1, :@to=>:$y, :@from=>:$x}}

    ruby.should parse_as(ast)
  end

end
