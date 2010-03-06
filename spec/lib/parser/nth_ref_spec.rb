require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "$1"' do
    ruby = '$1'
    ast  = {:nthref=>{:@line=>1, :@which=>1}}

    ruby.should parse_as(ast)
  end

end
