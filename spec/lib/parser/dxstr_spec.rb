require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "`touch ...`"' do
    ruby = <<-ruby
        t = 5
        `touch \#{t}`
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:t,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>5}}}},
         {:dynamicexecutestring=>
           {:@string=>:"touch ",
            :@array=>
             [{:tostring=>
                {:@line=>2,
                 :@value=>
                  {:localvariableaccess=>
                    {:@variable=>nil, :@name=>:t, :@line=>2}}}}],
            :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
