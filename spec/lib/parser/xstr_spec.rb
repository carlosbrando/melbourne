require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "`touch 5`"' do
    ruby = '`touch 5`'
    ast  = {:executestring=>{:@string=>:"touch 5", :@line=>1}}

    ruby.should parse_as(ast)
  end

end
