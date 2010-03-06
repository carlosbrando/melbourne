require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "for o in ary ..."' do
    ruby = <<-ruby
        for o in ary do
          puts(o)
        end
      ruby
    ast  = {:send=>
      {:@block=>
        {:for=>
          {:@body=>
            {:sendwitharguments=>
              {:@block=>nil,
               :@name=>:puts,
               :@line=>2,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>2}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>
                    [{:localvariableaccess=>
                       {:@variable=>nil, :@name=>:o, :@line=>2}}],
                   :@splat=>nil,
                   :@line=>2}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>1,
               :@prelude=>:single,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-1,
               :@required_args=>1,
               :@arguments=>
                {:localvariableassignment=>
                  {:@variable=>nil, :@name=>:o, :@line=>1, :@value=>nil}}}}}},
       :@name=>:each,
       :@line=>1,
       :@privately=>false,
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:ary,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "for i in (0..max) ..."' do
    ruby = <<-ruby
        for i in (0..max) do
          # do nothing
        end
      ruby
    ast  = {:send=>
      {:@block=>
        {:for=>
          {:@body=>{},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>1,
               :@prelude=>:single,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-1,
               :@required_args=>1,
               :@arguments=>
                {:localvariableassignment=>
                  {:@variable=>nil, :@name=>:i, :@line=>1, :@value=>nil}}}}}},
       :@name=>:each,
       :@line=>1,
       :@privately=>false,
       :@receiver=>
        {:range=>
          {:@start=>{:fixnumliteral=>{:@line=>1, :@value=>0}},
           :@finish=>
            {:send=>
              {:@block=>nil,
               :@name=>:max,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "for a, b in x ..."' do
    ruby = <<-ruby
        for a, b in x do
          5
        end
      ruby
    ast  = {:send=>
      {:@block=>
        {:for=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>5}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>2,
               :@prelude=>:multi,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-1,
               :@required_args=>2,
               :@arguments=>
                {:masgn=>
                  {:@block=>nil,
                   :@iter_arguments=>true,
                   :@fixed=>false,
                   :@splat=>nil,
                   :@line=>1,
                   :@left=>
                    {:arrayliteral=>
                      {:@body=>
                        [{:localvariableassignment=>
                           {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
                         {:localvariableassignment=>
                           {:@variable=>nil,
                            :@name=>:b,
                            :@line=>1,
                            :@value=>nil}}],
                       :@line=>1}},
                   :@right=>nil}}}}}},
       :@name=>:each,
       :@line=>1,
       :@privately=>false,
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:x,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "for i in () ..."' do
    ruby = <<-ruby
        for i in ()
          i
        end
      ruby
    ast  = {:send=>
      {:@block=>
        {:for=>
          {:@body=>
            {:localvariableaccess=>{:@variable=>nil, :@name=>:i, :@line=>2}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>1,
               :@prelude=>:single,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-1,
               :@required_args=>1,
               :@arguments=>
                {:localvariableassignment=>
                  {:@variable=>nil, :@name=>:i, :@line=>1, :@value=>nil}}}}}},
       :@name=>:each,
       :@line=>1,
       :@privately=>false,
       :@receiver=>{},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "for i in a ... for j in b ..."' do
    ruby = <<-ruby
        c = 1
        for i in a
          for j in b
            c
          end
        end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:c,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:send=>
           {:@block=>
             {:for=>
               {:@body=>
                 {:send=>
                   {:@block=>
                     {:for=>
                       {:@body=>
                         {:localvariableaccess=>
                           {:@variable=>nil, :@name=>:c, :@line=>4}},
                        :@line=>3,
                        :@arguments=>
                         {:iterarguments=>
                           {:@block=>nil,
                            :@arity=>1,
                            :@prelude=>:single,
                            :@optional=>0,
                            :@splat=>nil,
                            :@line=>3,
                            :@splat_index=>-1,
                            :@required_args=>1,
                            :@arguments=>
                             {:localvariableassignment=>
                               {:@variable=>nil,
                                :@name=>:j,
                                :@line=>3,
                                :@value=>nil}}}}}},
                    :@name=>:each,
                    :@line=>3,
                    :@privately=>false,
                    :@receiver=>
                     {:send=>
                       {:@block=>nil,
                        :@name=>:b,
                        :@line=>3,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>3}},
                        :@check_for_local=>false}},
                    :@check_for_local=>false}},
                :@line=>2,
                :@arguments=>
                 {:iterarguments=>
                   {:@block=>nil,
                    :@arity=>1,
                    :@prelude=>:single,
                    :@optional=>0,
                    :@splat=>nil,
                    :@line=>2,
                    :@splat_index=>-1,
                    :@required_args=>1,
                    :@arguments=>
                     {:localvariableassignment=>
                       {:@variable=>nil, :@name=>:i, :@line=>2, :@value=>nil}}}}}},
            :@name=>:each,
            :@line=>2,
            :@privately=>false,
            :@receiver=>
             {:send=>
               {:@block=>nil,
                :@name=>:a,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false}},
            :@check_for_local=>false}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
