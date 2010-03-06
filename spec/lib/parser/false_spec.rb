require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "false"' do
    ruby = 'false'
    ast  = {:false=>{:@line=>1}}

    ruby.should parse_as(ast)
  end

end
