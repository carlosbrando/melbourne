require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "true"' do
    ruby = 'true'
    ast  = {:true=>{:@line=>1}}

    ruby.should parse_as(ast)
  end

end
