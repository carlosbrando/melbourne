require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "1 if /x/"' do
    ruby = '1 if /x/'
    ast  = {:if=>
      {:@body=>{:fixnumliteral=>{:@line=>1, :@value=>1}},
       :@condition=>
        {:match=>
          {:@line=>1,
           :@pattern=>{:regexliteral=>{:@source=>:x, :@options=>0, :@line=>1}}}},
       :@else=>{},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
