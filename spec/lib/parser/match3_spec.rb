require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse ""blah" =~ /x/"' do
    ruby = '"blah" =~ /x/'
    ast  = {:match3=>
      {:@line=>1,
       :@value=>{:stringliteral=>{:@string=>:blah, :@line=>1}},
       :@pattern=>{:regexliteral=>{:@source=>:x, :@options=>0, :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = "abc"; if a =~ /#{a}/ ..."' do
    ruby = <<-ruby
        a = 'abc'
        if a =~ /\#{a}/
          1
        end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:stringliteral=>{:@string=>:abc, :@line=>1}}}},
         {:if=>
           {:@body=>{:fixnumliteral=>{:@line=>3, :@value=>1}},
            :@condition=>
             {:match3=>
               {:@line=>2,
                :@value=>
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
                :@pattern=>
                 {:dynamicregex=>
                   {:@string=>:"<blank>",
                    :@array=>
                     [{:tostring=>
                        {:@line=>2,
                         :@value=>
                          {:localvariableaccess=>
                            {:@variable=>nil, :@name=>:a, :@line=>2}}}}],
                    :@options=>0,
                    :@line=>2}}}},
            :@else=>{},
            :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
