require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "/x/ =~ "blah""' do
    ruby = '/x/ =~ "blah"'
    ast  = {:match2=>
      {:@line=>1,
       :@value=>{:stringliteral=>{:@string=>:blah, :@line=>1}},
       :@pattern=>{:regexliteral=>{:@source=>:x, :@options=>0, :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "x = "x"; /#{x}/ =~ x"' do
    ruby = <<-ruby
        x = "x"
        /\#{x}/ =~ x
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:x,
            :@line=>1,
            :@value=>{:stringliteral=>{:@string=>:x, :@line=>1}}}},
         {:match2=>
           {:@line=>2,
            :@value=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:x, :@line=>2}},
            :@pattern=>
             {:dynamicregex=>
               {:@string=>:"<blank>",
                :@array=>
                 [{:tostring=>
                    {:@line=>2,
                     :@value=>
                      {:localvariableaccess=>
                        {:@variable=>nil, :@name=>:x, :@line=>2}}}}],
                :@options=>0,
                :@line=>2}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
