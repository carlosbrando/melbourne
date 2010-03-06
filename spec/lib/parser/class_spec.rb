require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "class X ..."' do
    ruby = <<-ruby
        class X
          puts((1 + 1))
          def blah
            puts("hello")
          end
        end
      ruby
    ast  = {:class=>
      {:@superclass=>{},
       :@body=>
        {:classscope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:sendwitharguments=>
                   {:@block=>nil,
                    :@name=>:puts,
                    :@line=>2,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>2}},
                    :@check_for_local=>false,
                    :@arguments=>
                     {:actualarguments=>
                       {:@array=>
                         [{:sendwitharguments=>
                            {:@block=>nil,
                             :@name=>:+,
                             :@line=>2,
                             :@privately=>false,
                             :@receiver=>{:fixnumliteral=>{:@line=>2, :@value=>1}},
                             :@check_for_local=>false,
                             :@arguments=>
                              {:actualarguments=>
                                {:@array=>
                                  [{:fixnumliteral=>{:@line=>2, :@value=>1}}],
                                 :@splat=>nil,
                                 :@line=>2}}}}],
                        :@splat=>nil,
                        :@line=>2}}}},
                 {:define=>
                   {:@body=>
                     {:block=>
                       {:@array=>
                         [{:sendwitharguments=>
                           {:@block=>nil,
                             :@name=>:puts,
                             :@line=>4,
                             :@privately=>true,
                             :@receiver=>{:self=>{:@line=>4}},
                             :@check_for_local=>false,
                             :@arguments=>
                              {:actualarguments=>
                                {:@array=>
                                  [{:stringliteral=>
                                     {:@string=>:hello, :@line=>4}}],
                                 :@splat=>nil,
                                 :@line=>4}}}}],
                        :@line=>3}},
                    :@name=>:blah,
                    :@line=>3,
                    :@arguments=>
                     {:formalarguments=>
                       {:@block_arg=>nil,
                        :@names=>[],
                        :@defaults=>nil,
                        :@optional=>[],
                        :@splat=>nil,
                        :@line=>3,
                        :@required=>[]}}}}],
               :@line=>2}},
           :@name=>:X,
           :@line=>1}},
       :@name=>{:classname=>{:@superclass=>{}, :@name=>:X, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "class ::Y ..."' do
    ruby = <<-ruby
        class ::Y
          c
        end
      ruby
    ast  = {:class=>
      {:@superclass=>{},
       :@body=>
        {:classscope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:send=>
                   {:@block=>nil,
                    :@name=>:c,
                    :@line=>2,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>2}},
                    :@check_for_local=>false}}],
               :@line=>3}},
           :@name=>:Y,
           :@line=>1}},
       :@name=>
        {:scopedclassname=>
          {:@superclass=>{},
           :@parent=>{:toplevel=>{:@line=>1}},
           :@name=>:Y,
           :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "class X::Y ..."' do
    ruby = <<-ruby
        class X::Y
          c
        end
      ruby
    ast  = {:class=>
      {:@superclass=>{},
       :@body=>
        {:classscope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:send=>
                   {:@block=>nil,
                    :@name=>:c,
                    :@line=>2,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>2}},
                    :@check_for_local=>false}}],
               :@line=>3}},
           :@name=>:Y,
           :@line=>1}},
       :@name=>
        {:scopedclassname=>
          {:@superclass=>{},
           :@parent=>{:constfind=>{:@name=>:X, :@line=>1}},
           :@name=>:Y,
           :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "class X < Array; end"' do
    ruby = <<-ruby
        class X < Array
        end
      ruby
    ast  = {:class=>
      {:@superclass=>{:constfind=>{:@name=>:Array, :@line=>1}},
       :@body=>{:emptybody=>{:@line=>1}},
       :@name=>
        {:classname=>
          {:@superclass=>{:constfind=>{:@name=>:Array, :@line=>1}},
           :@name=>:X,
           :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "class X < expr; end"' do
    ruby = <<-ruby
        class X < expr
        end
      ruby
    ast  = {:class=>
      {:@superclass=>
        {:send=>
          {:@block=>nil,
           :@name=>:expr,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@body=>{:emptybody=>{:@line=>1}},
       :@name=>
        {:classname=>
          {:@superclass=>
            {:send=>
              {:@block=>nil,
               :@name=>:expr,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@name=>:X,
           :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "class X < Object; end"' do
    ruby = <<-ruby
        class X < Object
        end
      ruby
    ast  = {:class=>
      {:@superclass=>{:constfind=>{:@name=>:Object, :@line=>1}},
       :@body=>{:emptybody=>{:@line=>1}},
       :@name=>
        {:classname=>
          {:@superclass=>{:constfind=>{:@name=>:Object, :@line=>1}},
           :@name=>:X,
           :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
