require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "$x = 42"' do
    ruby = '$x = 42'
    ast  = {:globalvariableassignment=>
      {:@name=>:$x,
       :@line=>1,
       :@value=>{:fixnumliteral=>{:@line=>1, :@value=>42}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "$a = *[1]"' do
    ruby = '$a = *[1]'
    ast  = {:globalvariableassignment=>
      {:@name=>:$a,
       :@line=>1,
       :@value=>
        {:svalue=>
          {:@line=>1,
           :@value=>
            {:splatvalue=>
              {:@line=>1,
               :@value=>
                {:arrayliteral=>
                  {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                   :@line=>1}}}}}}}}

    ruby.should parse_as(ast)
  end

end
