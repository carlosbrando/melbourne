require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "m { }"' do
    ruby = 'm { }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>{},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m do end"' do
    ruby = 'm do end'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>{},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { x }"' do
    ruby = 'm { x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:x,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { || x }"' do
    ruby = 'm { || x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:x,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>0,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-1,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { |a| a + x }"' do
    ruby = 'm { |a| a + x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:sendwitharguments=>
              {:@block=>nil,
               :@name=>:+,
               :@line=>1,
               :@privately=>false,
               :@receiver=>
                {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>1}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>
                    [{:send=>
                       {:@block=>nil,
                        :@name=>:x,
                        :@line=>1,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>1}},
                        :@check_for_local=>false}}],
                   :@splat=>nil,
                   :@line=>1}}}},
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
                  {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}}}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { |*| x }"' do
    ruby = 'm { |*| x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:x,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>:multi,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-1,
               :@required_args=>0,
               :@arguments=>
                {:masgn=>
                  {:@block=>nil,
                   :@iter_arguments=>true,
                   :@fixed=>false,
                   :@splat=>nil,
                   :@line=>1,
                   :@left=>nil,
                   :@right=>nil}}}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { |*c| x; c }"' do
    ruby = 'm { |*c| x; c }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:send=>
                   {:@block=>nil,
                    :@name=>:x,
                    :@line=>1,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>1}},
                    :@check_for_local=>false}},
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:c, :@line=>1}}],
               :@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>:splat,
               :@optional=>1,
               :@splat=>
                {:localvariableassignment=>
                  {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}},
               :@line=>1,
               :@splat_index=>-1,
               :@required_args=>0,
               :@arguments=>
                {:masgn=>
                  {:@block=>nil,
                   :@iter_arguments=>true,
                   :@fixed=>false,
                   :@splat=>
                    {:localvariableassignment=>
                      {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}},
                   :@line=>1,
                   :@left=>nil,
                   :@right=>nil}}}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { |a, | a + x }"' do
    ruby = 'm { |a, | a + x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:sendwitharguments=>
              {:@block=>nil,
               :@name=>:+,
               :@line=>1,
               :@privately=>false,
               :@receiver=>
                {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>1}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>
                    [{:send=>
                       {:@block=>nil,
                        :@name=>:x,
                        :@line=>1,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>1}},
                        :@check_for_local=>false}}],
                   :@splat=>nil,
                   :@line=>1}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>1,
               :@prelude=>:multi,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-1,
               :@required_args=>1,
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
                           {:@variable=>nil,
                            :@name=>:a,
                            :@line=>1,
                            :@value=>nil}}],
                       :@line=>1}},
                   :@right=>nil}}}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { |a, *| a + x }"' do
    ruby = 'm { |a, *| a + x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:sendwitharguments=>
              {:@block=>nil,
               :@name=>:+,
               :@line=>1,
               :@privately=>false,
               :@receiver=>
                {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>1}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>
                    [{:send=>
                       {:@block=>nil,
                        :@name=>:x,
                        :@line=>1,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>1}},
                        :@check_for_local=>false}}],
                   :@splat=>nil,
                   :@line=>1}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>1,
               :@prelude=>:multi,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-1,
               :@required_args=>1,
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
                           {:@variable=>nil,
                            :@name=>:a,
                            :@line=>1,
                            :@value=>nil}}],
                       :@line=>1}},
                   :@right=>nil}}}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { |a, *c| a + x; c }"' do
    ruby = 'm { |a, *c| a + x; c }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:sendwitharguments=>
                   {:@block=>nil,
                    :@name=>:+,
                    :@line=>1,
                    :@privately=>false,
                    :@receiver=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:a, :@line=>1}},
                    :@check_for_local=>false,
                    :@arguments=>
                     {:actualarguments=>
                       {:@array=>
                         [{:send=>
                            {:@block=>nil,
                             :@name=>:x,
                             :@line=>1,
                             :@privately=>true,
                             :@receiver=>{:self=>{:@line=>1}},
                             :@check_for_local=>false}}],
                        :@splat=>nil,
                        :@line=>1}}}},
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:c, :@line=>1}}],
               :@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-2,
               :@prelude=>:multi,
               :@optional=>1,
               :@splat=>
                {:localvariableassignment=>
                  {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}},
               :@line=>1,
               :@splat_index=>-1,
               :@required_args=>1,
               :@arguments=>
                {:masgn=>
                  {:@block=>nil,
                   :@iter_arguments=>true,
                   :@fixed=>false,
                   :@splat=>
                    {:localvariableassignment=>
                      {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}},
                   :@line=>1,
                   :@left=>
                    {:arrayliteral=>
                      {:@body=>
                        [{:localvariableassignment=>
                           {:@variable=>nil,
                            :@name=>:a,
                            :@line=>1,
                            :@value=>nil}}],
                       :@line=>1}},
                   :@right=>nil}}}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { |a, b| a + x; b }"' do
    ruby = 'm { |a, b| a + x; b }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:sendwitharguments=>
                   {:@block=>nil,
                    :@name=>:+,
                    :@line=>1,
                    :@privately=>false,
                    :@receiver=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:a, :@line=>1}},
                    :@check_for_local=>false,
                    :@arguments=>
                     {:actualarguments=>
                       {:@array=>
                         [{:send=>
                            {:@block=>nil,
                             :@name=>:x,
                             :@line=>1,
                             :@privately=>true,
                             :@receiver=>{:self=>{:@line=>1}},
                             :@check_for_local=>false}}],
                        :@splat=>nil,
                        :@line=>1}}}},
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:b, :@line=>1}}],
               :@line=>1}},
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
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { |a, b, | a + x; b }"' do
    ruby = 'm { |a, b, | a + x; b }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:sendwitharguments=>
                   {:@block=>nil,
                    :@name=>:+,
                    :@line=>1,
                    :@privately=>false,
                    :@receiver=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:a, :@line=>1}},
                    :@check_for_local=>false,
                    :@arguments=>
                     {:actualarguments=>
                       {:@array=>
                         [{:send=>
                            {:@block=>nil,
                             :@name=>:x,
                             :@line=>1,
                             :@privately=>true,
                             :@receiver=>{:self=>{:@line=>1}},
                             :@check_for_local=>false}}],
                        :@splat=>nil,
                        :@line=>1}}}},
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:b, :@line=>1}}],
               :@line=>1}},
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
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { |a, b, *| a + x; b }"' do
    ruby = 'm { |a, b, *| a + x; b }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:sendwitharguments=>
                   {:@block=>nil,
                    :@name=>:+,
                    :@line=>1,
                    :@privately=>false,
                    :@receiver=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:a, :@line=>1}},
                    :@check_for_local=>false,
                    :@arguments=>
                     {:actualarguments=>
                       {:@array=>
                         [{:send=>
                            {:@block=>nil,
                             :@name=>:x,
                             :@line=>1,
                             :@privately=>true,
                             :@receiver=>{:self=>{:@line=>1}},
                             :@check_for_local=>false}}],
                        :@splat=>nil,
                        :@line=>1}}}},
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:b, :@line=>1}}],
               :@line=>1}},
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
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { |a, b, *c| a + x; b; c }"' do
    ruby = 'm { |a, b, *c| a + x; b; c }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:sendwitharguments=>
                   {:@block=>nil,
                    :@name=>:+,
                    :@line=>1,
                    :@privately=>false,
                    :@receiver=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:a, :@line=>1}},
                    :@check_for_local=>false,
                    :@arguments=>
                     {:actualarguments=>
                       {:@array=>
                         [{:send=>
                            {:@block=>nil,
                             :@name=>:x,
                             :@line=>1,
                             :@privately=>true,
                             :@receiver=>{:self=>{:@line=>1}},
                             :@check_for_local=>false}}],
                        :@splat=>nil,
                        :@line=>1}}}},
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:b, :@line=>1}},
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:c, :@line=>1}}],
               :@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-3,
               :@prelude=>:multi,
               :@optional=>1,
               :@splat=>
                {:localvariableassignment=>
                  {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}},
               :@line=>1,
               :@splat_index=>-1,
               :@required_args=>2,
               :@arguments=>
                {:masgn=>
                  {:@block=>nil,
                   :@iter_arguments=>true,
                   :@fixed=>false,
                   :@splat=>
                    {:localvariableassignment=>
                      {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}},
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
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m do |a, b, *c| a + x; b; c end"' do
    ruby = 'm do |a, b, *c| a + x; b; c end'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:sendwitharguments=>
                   {:@block=>nil,
                    :@name=>:+,
                    :@line=>1,
                    :@privately=>false,
                    :@receiver=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:a, :@line=>1}},
                    :@check_for_local=>false,
                    :@arguments=>
                     {:actualarguments=>
                       {:@array=>
                         [{:send=>
                            {:@block=>nil,
                             :@name=>:x,
                             :@line=>1,
                             :@privately=>true,
                             :@receiver=>{:self=>{:@line=>1}},
                             :@check_for_local=>false}}],
                        :@splat=>nil,
                        :@line=>1}}}},
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:b, :@line=>1}},
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:c, :@line=>1}}],
               :@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-3,
               :@prelude=>:multi,
               :@optional=>1,
               :@splat=>
                {:localvariableassignment=>
                  {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}},
               :@line=>1,
               :@splat_index=>-1,
               :@required_args=>2,
               :@arguments=>
                {:masgn=>
                  {:@block=>nil,
                   :@iter_arguments=>true,
                   :@fixed=>false,
                   :@splat=>
                    {:localvariableassignment=>
                      {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}},
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
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { n = 1; m { n } }"' do
    ruby = 'm { n = 1; m { n } }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:n,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
                 {:send=>
                   {:@block=>
                     {:iter=>
                       {:@body=>
                         {:localvariableaccess=>
                           {:@variable=>nil, :@name=>:n, :@line=>1}},
                        :@line=>1,
                        :@arguments=>
                         {:iterarguments=>
                           {:@block=>nil,
                            :@arity=>-1,
                            :@prelude=>nil,
                            :@optional=>0,
                            :@splat=>nil,
                            :@line=>1,
                            :@splat_index=>-2,
                            :@required_args=>0}}}},
                    :@name=>:m,
                    :@line=>1,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>1}},
                    :@check_for_local=>false}}],
               :@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "n = 1; m { n = 2 }; n"' do
    ruby = 'n = 1; m { n = 2 }; n'
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:n,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:send=>
           {:@block=>
             {:iter=>
               {:@body=>
                 {:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:n,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>2}}}},
                :@line=>1,
                :@arguments=>
                 {:iterarguments=>
                   {:@block=>nil,
                    :@arity=>-1,
                    :@prelude=>nil,
                    :@optional=>0,
                    :@splat=>nil,
                    :@line=>1,
                    :@splat_index=>-2,
                    :@required_args=>0}}}},
            :@name=>:m,
            :@line=>1,
            :@privately=>true,
            :@receiver=>{:self=>{:@line=>1}},
            :@check_for_local=>false}},
         {:localvariableaccess=>{:@variable=>nil, :@name=>:n, :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m(a) { |b| a + x }"' do
    ruby = 'm(a) { |b| a + x }'
    ast  = {:sendwitharguments=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:sendwitharguments=>
              {:@block=>nil,
               :@name=>:+,
               :@line=>1,
               :@privately=>false,
               :@receiver=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:a,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>
                    [{:send=>
                       {:@block=>nil,
                        :@name=>:x,
                        :@line=>1,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>1}},
                        :@check_for_local=>false}}],
                   :@splat=>nil,
                   :@line=>1}}}},
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
                  {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:send=>
               {:@block=>nil,
                :@name=>:a,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { |a| a + x }"' do
    ruby = <<-ruby
        m { |a|
          a + x
        }
      ruby
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:sendwitharguments=>
              {:@block=>nil,
               :@name=>:+,
               :@line=>2,
               :@privately=>false,
               :@receiver=>
                {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>
                    [{:send=>
                       {:@block=>nil,
                        :@name=>:x,
                        :@line=>2,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>2}},
                        :@check_for_local=>false}}],
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
                  {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}}}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m do |a| a + x end"' do
    ruby = <<-ruby
        m do |a|
          a + x
        end
      ruby
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:sendwitharguments=>
              {:@block=>nil,
               :@name=>:+,
               :@line=>2,
               :@privately=>false,
               :@receiver=>
                {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>
                    [{:send=>
                       {:@block=>nil,
                        :@name=>:x,
                        :@line=>2,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>2}},
                        :@check_for_local=>false}}],
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
                  {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}}}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "obj.m { |a| a + x }"' do
    ruby = 'obj.m { |a| a + x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:sendwitharguments=>
              {:@block=>nil,
               :@name=>:+,
               :@line=>1,
               :@privately=>false,
               :@receiver=>
                {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>1}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>
                    [{:send=>
                       {:@block=>nil,
                        :@name=>:x,
                        :@line=>1,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>1}},
                        :@check_for_local=>false}}],
                   :@splat=>nil,
                   :@line=>1}}}},
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
                  {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}}}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>false,
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:obj,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "obj.m(x) { |a| a + x }"' do
    ruby = 'obj.m(x) { |a| a + x }'
    ast  = {:sendwitharguments=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:sendwitharguments=>
              {:@block=>nil,
               :@name=>:+,
               :@line=>1,
               :@privately=>false,
               :@receiver=>
                {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>1}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>
                    [{:send=>
                       {:@block=>nil,
                        :@name=>:x,
                        :@line=>1,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>1}},
                        :@check_for_local=>false}}],
                   :@splat=>nil,
                   :@line=>1}}}},
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
                  {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}}}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>false,
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:obj,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:send=>
               {:@block=>nil,
                :@name=>:x,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "obj.m(a) { |a| a + x }"' do
    ruby = 'obj.m(a) { |a| a + x }'
    ast  = {:sendwitharguments=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:sendwitharguments=>
              {:@block=>nil,
               :@name=>:+,
               :@line=>1,
               :@privately=>false,
               :@receiver=>
                {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>1}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>
                    [{:send=>
                       {:@block=>nil,
                        :@name=>:x,
                        :@line=>1,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>1}},
                        :@check_for_local=>false}}],
                   :@splat=>nil,
                   :@line=>1}}}},
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
                  {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}}}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>false,
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:obj,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:send=>
               {:@block=>nil,
                :@name=>:a,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = 1; m { |a| a + x }"' do
    ruby = 'a = 1; m { |a| a + x }'
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:send=>
           {:@block=>
             {:iter=>
               {:@body=>
                 {:sendwitharguments=>
                   {:@block=>nil,
                    :@name=>:+,
                    :@line=>1,
                    :@privately=>false,
                    :@receiver=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:a, :@line=>1}},
                    :@check_for_local=>false,
                    :@arguments=>
                     {:actualarguments=>
                       {:@array=>
                         [{:send=>
                            {:@block=>nil,
                             :@name=>:x,
                             :@line=>1,
                             :@privately=>true,
                             :@receiver=>{:self=>{:@line=>1}},
                             :@check_for_local=>false}}],
                        :@splat=>nil,
                        :@line=>1}}}},
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
                       {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}}}}}},
            :@name=>:m,
            :@line=>1,
            :@privately=>true,
            :@receiver=>{:self=>{:@line=>1}},
            :@check_for_local=>false}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "do ... begin ... rescue ..."' do
    ruby = <<-ruby
        x = nil
        m do |a|
          begin
            x
          rescue Exception => x
            break
          ensure
            x = a
          end
        end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil, :@name=>:x, :@line=>1, :@value=>{}}},
         {:send=>
           {:@block=>
             {:iter=>
               {:@body=>
                 {:begin=>
                   {:@rescue=>
                     {:ensure=>
                       {:@ensure=>
                         {:localvariableassignment=>
                           {:@variable=>nil,
                            :@name=>:x,
                            :@line=>8,
                            :@value=>
                             {:localvariableaccess=>
                               {:@variable=>nil, :@name=>:a, :@line=>8}}}},
                        :@body=>
                         {:rescue=>
                           {:@body=>
                             {:localvariableaccess=>
                               {:@variable=>nil, :@name=>:x, :@line=>4}},
                            :@rescue=>
                             {:rescuecondition=>
                               {:@conditions=>
                                 {:arrayliteral=>
                                   {:@body=>
                                     [{:constfind=>
                                        {:@name=>:Exception, :@line=>5}}],
                                    :@line=>5}},
                                :@body=>
                                 {:block=>
                                   {:@array=>[{:break=>{:@line=>6, :@value=>{}}}],
                                    :@line=>5}},
                                :@splat=>nil,
                                :@next=>nil,
                                :@line=>5,
                                :@assignment=>
                                 {:localvariableassignment=>
                                   {:@variable=>nil,
                                    :@name=>:x,
                                    :@line=>5,
                                    :@value=>
                                     {:globalvariableaccess=>
                                       {:@name=>:$!, :@line=>7}}}}}},
                            :@else=>nil,
                            :@line=>9}},
                        :@line=>4}},
                    :@line=>3}},
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
                       {:@variable=>nil, :@name=>:a, :@line=>2, :@value=>nil}}}}}},
            :@name=>:m,
            :@line=>2,
            :@privately=>true,
            :@receiver=>{:self=>{:@line=>2}},
            :@check_for_local=>false}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { next }"' do
    ruby = 'm { next }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>{:next=>{:@line=>1, :@value=>nil}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { next if x }"' do
    ruby = 'm { next if x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:if=>
              {:@body=>{:next=>{:@line=>1, :@value=>nil}},
               :@condition=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:x,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}},
               :@else=>{},
               :@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { next x }"' do
    ruby = 'm { next x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:next=>
              {:@line=>1,
               :@value=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:x,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { x = 1; next x }"' do
    ruby = 'm { x = 1; next x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:x,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
                 {:next=>
                   {:@line=>1,
                    :@value=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:x, :@line=>1}}}}],
               :@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { next [1] }"' do
    ruby = 'm { next [1] }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:next=>
              {:@line=>1,
               :@value=>
                {:arrayliteral=>
                  {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                   :@line=>1}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { next *[1] }"' do
    ruby = 'm { next *[1] }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:next=>
              {:@line=>1,
               :@value=>
                {:svalue=>
                  {:@line=>1,
                   :@value=>
                    {:splatvalue=>
                      {:@line=>1,
                       :@value=>
                        {:arrayliteral=>
                          {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                           :@line=>1}}}}}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { next [*[1]] }"' do
    ruby = 'm { next [*[1]] }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:next=>
              {:@line=>1,
               :@value=>
                {:splatvalue=>
                  {:@line=>1,
                   :@value=>
                    {:arrayliteral=>
                      {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                       :@line=>1}}}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { next *[1, 2] }"' do
    ruby = 'm { next *[1, 2] }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:next=>
              {:@line=>1,
               :@value=>
                {:svalue=>
                  {:@line=>1,
                   :@value=>
                    {:splatvalue=>
                      {:@line=>1,
                       :@value=>
                        {:arrayliteral=>
                          {:@body=>
                            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
                             {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                           :@line=>1}}}}}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { next [*[1, 2]] }"' do
    ruby = 'm { next [*[1, 2]] }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:next=>
              {:@line=>1,
               :@value=>
                {:splatvalue=>
                  {:@line=>1,
                   :@value=>
                    {:arrayliteral=>
                      {:@body=>
                        [{:fixnumliteral=>{:@line=>1, :@value=>1}},
                         {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                       :@line=>1}}}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { break }"' do
    ruby = 'm { break }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>{:break=>{:@line=>1, :@value=>{}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { break if x }"' do
    ruby = 'm { break if x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:if=>
              {:@body=>{:break=>{:@line=>1, :@value=>{}}},
               :@condition=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:x,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}},
               :@else=>{},
               :@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { break x }"' do
    ruby = 'm { break x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:break=>
              {:@line=>1,
               :@value=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:x,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { x = 1; break x }"' do
    ruby = 'm { x = 1; break x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:x,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
                 {:break=>
                   {:@line=>1,
                    :@value=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:x, :@line=>1}}}}],
               :@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { break [1] }"' do
    ruby = 'm { break [1] }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:break=>
              {:@line=>1,
               :@value=>
                {:arrayliteral=>
                  {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                   :@line=>1}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { break *[1] }"' do
    ruby = 'm { break *[1] }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:break=>
              {:@line=>1,
               :@value=>
                {:svalue=>
                  {:@line=>1,
                   :@value=>
                    {:splatvalue=>
                      {:@line=>1,
                       :@value=>
                        {:arrayliteral=>
                          {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                           :@line=>1}}}}}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { break [*[1]] }"' do
    ruby = 'm { break [*[1]] }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:break=>
              {:@line=>1,
               :@value=>
                {:splatvalue=>
                  {:@line=>1,
                   :@value=>
                    {:arrayliteral=>
                      {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                       :@line=>1}}}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { break *[1, 2] }"' do
    ruby = 'm { break *[1, 2] }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:break=>
              {:@line=>1,
               :@value=>
                {:svalue=>
                  {:@line=>1,
                   :@value=>
                    {:splatvalue=>
                      {:@line=>1,
                       :@value=>
                        {:arrayliteral=>
                          {:@body=>
                            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
                             {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                           :@line=>1}}}}}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { break [*[1, 2]] }"' do
    ruby = 'm { break [*[1, 2]] }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:break=>
              {:@line=>1,
               :@value=>
                {:splatvalue=>
                  {:@line=>1,
                   :@value=>
                    {:arrayliteral=>
                      {:@body=>
                        [{:fixnumliteral=>{:@line=>1, :@value=>1}},
                         {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                       :@line=>1}}}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { return }"' do
    ruby = 'm { return }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>{:return=>{:@splat=>nil, :@line=>1, :@value=>nil}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { return if x }"' do
    ruby = 'm { return if x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:if=>
              {:@body=>{:return=>{:@splat=>nil, :@line=>1, :@value=>nil}},
               :@condition=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:x,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}},
               :@else=>{},
               :@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { return x }"' do
    ruby = 'm { return x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:return=>
              {:@splat=>nil,
               :@line=>1,
               :@value=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:x,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { x = 1; return x }"' do
    ruby = 'm { x = 1; return x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:x,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
                 {:return=>
                   {:@splat=>nil,
                    :@line=>1,
                    :@value=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:x, :@line=>1}}}}],
               :@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { return [1] }"' do
    ruby = 'm { return [1] }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:return=>
              {:@splat=>nil,
               :@line=>1,
               :@value=>
                {:arrayliteral=>
                  {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                   :@line=>1}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { return *[1] }"' do
    ruby = 'm { return *[1] }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:return=>
              {:@splat=>nil,
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
                           :@line=>1}}}}}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { return *[1, 2] }"' do
    ruby = 'm { return *[1, 2] }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:return=>
              {:@splat=>nil,
               :@line=>1,
               :@value=>
                {:svalue=>
                  {:@line=>1,
                   :@value=>
                    {:splatvalue=>
                      {:@line=>1,
                       :@value=>
                        {:arrayliteral=>
                          {:@body=>
                            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
                             {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                           :@line=>1}}}}}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { return [*[1, 2]] }"' do
    ruby = 'm { return [*[1, 2]] }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:return=>
              {:@splat=>nil,
               :@line=>1,
               :@value=>
                {:splatvalue=>
                  {:@line=>1,
                   :@value=>
                    {:arrayliteral=>
                      {:@body=>
                        [{:fixnumliteral=>{:@line=>1, :@value=>1}},
                         {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                       :@line=>1}}}}}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { redo }"' do
    ruby = 'm { redo }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>{:redo=>{:@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { redo if x }"' do
    ruby = 'm { redo if x }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:if=>
              {:@body=>{:redo=>{:@line=>1}},
               :@condition=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:x,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}},
               :@else=>{},
               :@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m(a) { retry }"' do
    ruby = 'm(a) { retry }'
    ast  = {:sendwitharguments=>
      {:@block=>
        {:iter=>
          {:@body=>{:retry=>{:@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:send=>
               {:@block=>nil,
                :@name=>:a,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m(a) { retry if x }"' do
    ruby = 'm(a) { retry if x }'
    ast  = {:sendwitharguments=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:if=>
              {:@body=>{:retry=>{:@line=>1}},
               :@condition=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:x,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}},
               :@else=>{},
               :@line=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:send=>
               {:@block=>nil,
                :@name=>:a,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "redo"' do
    ruby = 'redo'
    ast  = {:redo=>{:@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "retry"' do
    ruby = 'retry'
    ast  = {:retry=>{:@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "next"' do
    ruby = 'next'
    ast  = {:next=>{:@line=>1, :@value=>nil}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def x(a); bar { super } end"' do
    ruby = <<-ruby
        def x(a)
          bar { super }
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:send=>
               {:@block=>
                 {:iter=>
                   {:@body=>{:zsuper=>{:@block=>nil, :@line=>2}},
                    :@line=>2,
                    :@arguments=>
                     {:iterarguments=>
                       {:@block=>nil,
                        :@arity=>-1,
                        :@prelude=>nil,
                        :@optional=>0,
                        :@splat=>nil,
                        :@line=>2,
                        :@splat_index=>-2,
                        :@required_args=>0}}}},
                :@name=>:bar,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false}}],
           :@line=>1}},
       :@name=>:x,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:a],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[:a]}}}}

    ruby.should parse_as(ast)
  end

end
