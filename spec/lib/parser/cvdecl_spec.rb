require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "def x; @@blah = 1; end"' do
    ruby = <<-ruby
        class X
          @@blah = 1
        end
      ruby
    ast  = {:class=>
      {:@superclass=>{},
       :@body=>
        {:classscope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:classvariableassignment=>
                   {:@name=>:@@blah,
                    :@line=>2,
                    :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}}],
               :@line=>3}},
           :@name=>:X,
           :@line=>1}},
       :@name=>{:classname=>{:@superclass=>{}, :@name=>:X, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
