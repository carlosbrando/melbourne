require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "(not true)"' do
    ruby = '(not true)'
    ast  = {:not=>{:@line=>1, :@value=>{:true=>{:@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = 1; b = !a"' do
    ruby = <<-ruby
        a = 1
        b = !a
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:b,
            :@line=>2,
            :@value=>
             {:not=>
               {:@line=>2,
                :@value=>
                 {:localvariableaccess=>
                   {:@variable=>nil, :@name=>:a, :@line=>2}}}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
