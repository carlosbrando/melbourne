require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "@a = 4"' do
    ruby = '@a = 4'
    ast  = {:instancevariableassignment=>
      {:@name=>:@a, :@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>4}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "@a = *[1]"' do
    ruby = '@a = *[1]'
    ast  = {:instancevariableassignment=>
      {:@name=>:@a,
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

  it 'should correctly parse "a = 1; @a = a"' do
    ruby = <<-ruby
        a = 1
        @a = a
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:instancevariableassignment=>
           {:@name=>:@a,
            :@line=>2,
            :@value=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
