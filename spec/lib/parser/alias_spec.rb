require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "class X; alias :y :x; end"' do
    ruby = <<-ruby
        class X
          alias :y :x
        end
      ruby
    ast = {:class=>
      {:@superclass=>{},
       :@body=>
        {:classscope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:alias=>
                   {:@line=>2,
                    :@to=>{:symbolliteral=>{:@line=>2, :@value=>:y}},
                    :@from=>{:symbolliteral=>{:@line=>2, :@value=>:x}}}}],
               :@line=>3}},
           :@name=>:X,
           :@line=>1}},
       :@name=>{:classname=>{:@superclass=>{}, :@name=>:X, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "class X; alias y x; end"' do
    ruby = <<-ruby
        class X
          alias y x
        end
      ruby
    ast = {:class=>
      {:@superclass=>{},
       :@body=>
        {:classscope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:alias=>
                   {:@line=>2,
                    :@to=>{:symbolliteral=>{:@line=>2, :@value=>:y}},
                    :@from=>{:symbolliteral=>{:@line=>2, :@value=>:x}}}}],
               :@line=>3}},
           :@name=>:X,
           :@line=>1}},
       :@name=>{:classname=>{:@superclass=>{}, :@name=>:X, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "class X; alias :"y#{1}" :"x#{2}"; end"' do
    ruby = <<-ruby
        class X
          alias :"y\#{1}" :"x\#{2}"
        end
      ruby
    ast = {:class=>
      {:@superclass=>{},
       :@body=>
        {:classscope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:alias=>
                   {:@line=>2,
                    :@to=>
                     {:dynamicsymbol=>
                       {:@string=>:y,
                        :@array=>
                         [{:tostring=>
                            {:@line=>2,
                             :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}}],
                        :@line=>2}},
                    :@from=>
                     {:dynamicsymbol=>
                       {:@string=>:x,
                        :@array=>
                         [{:tostring=>
                            {:@line=>2,
                             :@value=>{:fixnumliteral=>{:@line=>2, :@value=>2}}}}],
                        :@line=>2}}}}],
               :@line=>3}},
           :@name=>:X,
           :@line=>1}},
       :@name=>{:classname=>{:@superclass=>{}, :@name=>:X, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
