require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "a, b.c = b.c, true"' do
    ruby = 'a, b.c = b.c, true'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:attributeassignment=>
               {:@name=>:c=,
                :@line=>1,
                :@privately=>false,
                :@receiver=>
                 {:send=>
                   {:@block=>nil,
                    :@name=>:b,
                    :@line=>1,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>1}},
                    :@check_for_local=>false}},
                :@arguments=>
                 {:actualarguments=>{:@array=>[], :@splat=>nil, :@line=>1}}}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:send=>
               {:@block=>nil,
                :@name=>:c,
                :@line=>1,
                :@privately=>false,
                :@receiver=>
                 {:send=>
                   {:@block=>nil,
                    :@name=>:b,
                    :@line=>1,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>1}},
                    :@check_for_local=>false}},
                :@check_for_local=>false}},
             {:true=>{:@line=>1}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b = 1, 2, 3"' do
    ruby = 'a, b = 1, 2, 3'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}},
             {:fixnumliteral=>{:@line=>1, :@value=>3}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b = c, d"' do
    ruby = 'a, b = c, d'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:send=>
               {:@block=>nil,
                :@name=>:c,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}},
             {:send=>
               {:@block=>nil,
                :@name=>:d,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b, *c = 1, 2, *[3, 4]"' do
    ruby = 'a, b, *c = 1, 2, *[3, 4]'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>
        {:splatassignment=>
          {:@line=>1,
           :@value=>
            {:localvariableassignment=>
              {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}}},
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:concatargs=>
          {:@array=>
            {:arrayliteral=>
              {:@body=>
                [{:fixnumliteral=>{:@line=>1, :@value=>1}},
                 {:fixnumliteral=>{:@line=>1, :@value=>2}}],
               :@line=>1}},
           :@size=>2,
           :@rest=>
            {:arrayliteral=>
              {:@body=>
                [{:fixnumliteral=>{:@line=>1, :@value=>3}},
                 {:fixnumliteral=>{:@line=>1, :@value=>4}}],
               :@line=>1}},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a.b, a.c, _ = q"' do
    ruby = 'a.b, a.c, _ = q'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:attributeassignment=>
               {:@name=>:b=,
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
                :@arguments=>
                 {:actualarguments=>{:@array=>[], :@splat=>nil, :@line=>1}}}},
             {:attributeassignment=>
               {:@name=>:c=,
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
                :@arguments=>
                 {:actualarguments=>{:@array=>[], :@splat=>nil, :@line=>1}}}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:_, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:toarray=>
          {:@line=>1,
           :@value=>
            {:send=>
              {:@block=>nil,
               :@name=>:q,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, i, j = [], 1, 2; a[i], a[j] = a[j], a[i]"' do
    ruby = <<-ruby
        a, i, j = [], 1, 2
        a[i], a[j] = a[j], a[i]
      ruby
    ast  = {:block=>
      {:@array=>
        [{:masgn=>
           {:@block=>nil,
            :@fixed=>true,
            :@splat=>nil,
            :@line=>1,
            :@left=>
             {:arrayliteral=>
               {:@body=>
                 [{:localvariableassignment=>
                    {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
                  {:localvariableassignment=>
                    {:@variable=>nil, :@name=>:i, :@line=>1, :@value=>nil}},
                  {:localvariableassignment=>
                    {:@variable=>nil, :@name=>:j, :@line=>1, :@value=>nil}}],
                :@line=>1}},
            :@right=>
             {:arrayliteral=>
               {:@body=>
                 [{:emptyarray=>{:@line=>1}},
                  {:fixnumliteral=>{:@line=>1, :@value=>1}},
                  {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                :@line=>1}}}},
         {:masgn=>
           {:@block=>nil,
            :@fixed=>true,
            :@splat=>nil,
            :@line=>2,
            :@left=>
             {:arrayliteral=>
               {:@body=>
                 [{:elementassignment=>
                    {:@name=>:[]=,
                     :@line=>2,
                     :@privately=>false,
                     :@receiver=>
                      {:localvariableaccess=>
                        {:@variable=>nil, :@name=>:a, :@line=>2}},
                     :@arguments=>
                      {:actualarguments=>
                        {:@array=>
                          [{:localvariableaccess=>
                             {:@variable=>nil, :@name=>:i, :@line=>2}}],
                         :@splat=>nil,
                         :@line=>2}}}},
                  {:elementassignment=>
                    {:@name=>:[]=,
                     :@line=>2,
                     :@privately=>false,
                     :@receiver=>
                      {:localvariableaccess=>
                        {:@variable=>nil, :@name=>:a, :@line=>2}},
                     :@arguments=>
                      {:actualarguments=>
                        {:@array=>
                          [{:localvariableaccess=>
                             {:@variable=>nil, :@name=>:j, :@line=>2}}],
                         :@splat=>nil,
                         :@line=>2}}}}],
                :@line=>2}},
            :@right=>
             {:arrayliteral=>
               {:@body=>
                 [{:sendwitharguments=>
                    {:@block=>nil,
                     :@name=>:[],
                     :@line=>2,
                     :@privately=>false,
                     :@receiver=>
                      {:localvariableaccess=>
                        {:@variable=>nil, :@name=>:a, :@line=>2}},
                     :@check_for_local=>false,
                     :@arguments=>
                      {:actualarguments=>
                        {:@array=>
                          [{:localvariableaccess=>
                             {:@variable=>nil, :@name=>:j, :@line=>2}}],
                         :@splat=>nil,
                         :@line=>2}}}},
                  {:sendwitharguments=>
                    {:@block=>nil,
                     :@name=>:[],
                     :@line=>2,
                     :@privately=>false,
                     :@receiver=>
                      {:localvariableaccess=>
                        {:@variable=>nil, :@name=>:a, :@line=>2}},
                     :@check_for_local=>false,
                     :@arguments=>
                      {:actualarguments=>
                        {:@array=>
                          [{:localvariableaccess=>
                             {:@variable=>nil, :@name=>:i, :@line=>2}}],
                         :@splat=>nil,
                         :@line=>2}}}}],
                :@line=>2}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "c, d, e, f = [], 1, 2, 3; a, *b = c[d] = f(e, f, c)"' do
    ruby = <<-ruby
        c, d, e, f = [], 1, 2, 3
        a, *b = c[d] = f(e, f, c)
      ruby
    ast  = {:block=>
      {:@array=>
        [{:masgn=>
           {:@block=>nil,
            :@fixed=>true,
            :@splat=>nil,
            :@line=>1,
            :@left=>
             {:arrayliteral=>
               {:@body=>
                 [{:localvariableassignment=>
                    {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}},
                  {:localvariableassignment=>
                    {:@variable=>nil, :@name=>:d, :@line=>1, :@value=>nil}},
                  {:localvariableassignment=>
                    {:@variable=>nil, :@name=>:e, :@line=>1, :@value=>nil}},
                  {:localvariableassignment=>
                    {:@variable=>nil, :@name=>:f, :@line=>1, :@value=>nil}}],
                :@line=>1}},
            :@right=>
             {:arrayliteral=>
               {:@body=>
                 [{:emptyarray=>{:@line=>1}},
                  {:fixnumliteral=>{:@line=>1, :@value=>1}},
                  {:fixnumliteral=>{:@line=>1, :@value=>2}},
                  {:fixnumliteral=>{:@line=>1, :@value=>3}}],
                :@line=>1}}}},
         {:masgn=>
           {:@block=>nil,
            :@fixed=>false,
            :@splat=>
             {:splatassignment=>
               {:@line=>2,
                :@value=>
                 {:localvariableassignment=>
                   {:@variable=>nil, :@name=>:b, :@line=>2, :@value=>nil}}}},
            :@line=>2,
            :@left=>
             {:arrayliteral=>
               {:@body=>
                 [{:localvariableassignment=>
                    {:@variable=>nil, :@name=>:a, :@line=>2, :@value=>nil}}],
                :@line=>2}},
            :@right=>
             {:toarray=>
               {:@line=>2,
                :@value=>
                 {:elementassignment=>
                   {:@name=>:[]=,
                    :@line=>2,
                    :@privately=>false,
                    :@receiver=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:c, :@line=>2}},
                    :@arguments=>
                     {:actualarguments=>
                       {:@array=>
                         [{:localvariableaccess=>
                            {:@variable=>nil, :@name=>:d, :@line=>2}},
                          {:sendwitharguments=>
                            {:@block=>nil,
                             :@name=>:f,
                             :@line=>2,
                             :@privately=>true,
                             :@receiver=>{:self=>{:@line=>2}},
                             :@check_for_local=>false,
                             :@arguments=>
                              {:actualarguments=>
                                {:@array=>
                                  [{:localvariableaccess=>
                                     {:@variable=>nil, :@name=>:e, :@line=>2}},
                                   {:localvariableaccess=>
                                     {:@variable=>nil, :@name=>:f, :@line=>2}},
                                   {:localvariableaccess=>
                                     {:@variable=>nil, :@name=>:c, :@line=>2}}],
                                 :@splat=>nil,
                                 :@line=>2}}}}],
                        :@splat=>nil,
                        :@line=>2}}}}}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b.c = d, e"' do
    ruby = 'a, b.c = d, e'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:attributeassignment=>
               {:@name=>:c=,
                :@line=>1,
                :@privately=>false,
                :@receiver=>
                 {:send=>
                   {:@block=>nil,
                    :@name=>:b,
                    :@line=>1,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>1}},
                    :@check_for_local=>false}},
                :@arguments=>
                 {:actualarguments=>{:@array=>[], :@splat=>nil, :@line=>1}}}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:send=>
               {:@block=>nil,
                :@name=>:d,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}},
             {:send=>
               {:@block=>nil,
                :@name=>:e,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "*a.m = *b"' do
    ruby = '*a.m = *b'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>
        {:attributeassignment=>
          {:@name=>:m=,
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
           :@arguments=>
            {:actualarguments=>{:@array=>[], :@splat=>nil, :@line=>1}}}},
       :@line=>1,
       :@left=>nil,
       :@right=>
        {:splatvalue=>
          {:@line=>1,
           :@value=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "*a.m = b"' do
    ruby = '*a.m = b'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>
        {:splatarray=>
          {:@size=>1,
           :@line=>1,
           :@value=>
            {:attributeassignment=>
              {:@name=>:m=,
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
               :@arguments=>
                {:actualarguments=>{:@array=>[], :@splat=>nil, :@line=>1}}}}}},
       :@line=>1,
       :@left=>nil,
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:send=>
               {:@block=>nil,
                :@name=>:b,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "A, B, C = 1, 2, 3"' do
    ruby = 'A, B, C = 1, 2, 3'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:constset=>
               {:@parent=>nil,
                :@name=>{:constname=>{:@name=>:A, :@line=>1}},
                :@line=>1,
                :@value=>nil}},
             {:constset=>
               {:@parent=>nil,
                :@name=>{:constname=>{:@name=>:B, :@line=>1}},
                :@line=>1,
                :@value=>nil}},
             {:constset=>
               {:@parent=>nil,
                :@name=>{:constname=>{:@name=>:C, :@line=>1}},
                :@line=>1,
                :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}},
             {:fixnumliteral=>{:@line=>1, :@value=>3}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "* = 1, 2"' do
    ruby = '* = 1, 2'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>{:emptysplat=>{:@size=>2, :@line=>1}},
       :@line=>1,
       :@left=>nil,
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "*$a = b"' do
    ruby = '*$a = b'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>
        {:splatarray=>
          {:@size=>1,
           :@line=>1,
           :@value=>
            {:globalvariableassignment=>{:@name=>:$a, :@line=>1, :@value=>nil}}}},
       :@line=>1,
       :@left=>nil,
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:send=>
               {:@block=>nil,
                :@name=>:b,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "*$a = *b"' do
    ruby = '*$a = *b'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>
        {:globalvariableassignment=>{:@name=>:$a, :@line=>1, :@value=>nil}},
       :@line=>1,
       :@left=>nil,
       :@right=>
        {:splatvalue=>
          {:@line=>1,
           :@value=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, @b = c, d"' do
    ruby = 'a, @b = c, d'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:instancevariableassignment=>
               {:@name=>:@b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:send=>
               {:@block=>nil,
                :@name=>:c,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}},
             {:send=>
               {:@block=>nil,
                :@name=>:d,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "*@a = b"' do
    ruby = '*@a = b'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>
        {:splatarray=>
          {:@size=>1,
           :@line=>1,
           :@value=>
            {:instancevariableassignment=>
              {:@name=>:@a, :@line=>1, :@value=>nil}}}},
       :@line=>1,
       :@left=>nil,
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:send=>
               {:@block=>nil,
                :@name=>:b,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "*@a = *b"' do
    ruby = '*@a = *b'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>
        {:instancevariableassignment=>{:@name=>:@a, :@line=>1, :@value=>nil}},
       :@line=>1,
       :@left=>nil,
       :@right=>
        {:splatvalue=>
          {:@line=>1,
           :@value=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "@a, $b = 1, 2"' do
    ruby = '@a, $b = 1, 2'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:instancevariableassignment=>{:@name=>:@a, :@line=>1, :@value=>nil}},
             {:globalvariableassignment=>{:@name=>:$b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b = (@a = 1), @a"' do
    ruby = 'a, b = (@a = 1), @a'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:instancevariableassignment=>
               {:@name=>:@a,
                :@line=>1,
                :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
             {:instancevariableaccess=>{:@name=>:@a, :@line=>1}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "@@a, @@b = 1, 2"' do
    ruby = '@@a, @@b = 1, 2'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:classvariableassignment=>{:@name=>:@@a, :@line=>1, :@value=>nil}},
             {:classvariableassignment=>{:@name=>:@@b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b, *c = 1, 2, 3"' do
    ruby = 'a, b, *c = 1, 2, 3'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>
        {:splatassignment=>
          {:@line=>1,
           :@value=>
            {:localvariableassignment=>
              {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}}},
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}},
             {:fixnumliteral=>{:@line=>1, :@value=>3}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b, *c = 1, 2"' do
    ruby = 'a, b, *c = 1, 2'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>
        {:splatassignment=>
          {:@line=>1,
           :@value=>
            {:localvariableassignment=>
              {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}}},
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b, c, *d = 1, 2"' do
    ruby = 'a, b, c, *d = 1, 2'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>
        {:splatassignment=>
          {:@line=>1,
           :@value=>
            {:localvariableassignment=>
              {:@variable=>nil, :@name=>:d, :@line=>1, :@value=>nil}}}},
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b, c = *d"' do
    ruby = 'a, b, c = *d'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:splatvalue=>
          {:@line=>1,
           :@value=>
            {:send=>
              {:@block=>nil,
               :@name=>:d,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b, c = 1, *d"' do
    ruby = 'a, b, c = 1, *d'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:concatargs=>
          {:@array=>
            {:arrayliteral=>
              {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}], :@line=>1}},
           :@size=>1,
           :@rest=>
            {:send=>
              {:@block=>nil,
               :@name=>:d,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b, *c = *d"' do
    ruby = 'a, b, *c = *d'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>
        {:splatassignment=>
          {:@line=>1,
           :@value=>
            {:localvariableassignment=>
              {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}}},
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:splatvalue=>
          {:@line=>1,
           :@value=>
            {:send=>
              {:@block=>nil,
               :@name=>:d,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "*a = 1, 2, 3"' do
    ruby = '*a = 1, 2, 3'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>
        {:splatarray=>
          {:@size=>3,
           :@line=>1,
           :@value=>
            {:localvariableassignment=>
              {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}}}},
       :@line=>1,
       :@left=>nil,
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}},
             {:fixnumliteral=>{:@line=>1, :@value=>3}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "*a = b"' do
    ruby = '*a = b'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>
        {:splatarray=>
          {:@size=>1,
           :@line=>1,
           :@value=>
            {:localvariableassignment=>
              {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}}}},
       :@line=>1,
       :@left=>nil,
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:send=>
               {:@block=>nil,
                :@name=>:b,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "*a = *b"' do
    ruby = '*a = *b'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>
        {:localvariableassignment=>
          {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
       :@line=>1,
       :@left=>nil,
       :@right=>
        {:splatvalue=>
          {:@line=>1,
           :@value=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, (b, c) = [1, [2, 3]]"' do
    ruby = 'a, (b, c) = [1, [2, 3]]'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:masgn=>
               {:@block=>nil,
                :@fixed=>false,
                :@splat=>nil,
                :@line=>1,
                :@left=>
                 {:arrayliteral=>
                   {:@body=>
                     [{:localvariableassignment=>
                        {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}},
                      {:localvariableassignment=>
                        {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}],
                    :@line=>1}},
                :@right=>nil}}],
           :@line=>1}},
       :@right=>
        {:toarray=>
          {:@line=>1,
           :@value=>
            {:arrayliteral=>
              {:@body=>
                [{:fixnumliteral=>{:@line=>1, :@value=>1}},
                 {:arrayliteral=>
                   {:@body=>
                     [{:fixnumliteral=>{:@line=>1, :@value=>2}},
                      {:fixnumliteral=>{:@line=>1, :@value=>3}}],
                    :@line=>1}}],
               :@line=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, = *[[[1]]]"' do
    ruby = 'a, = *[[[1]]]'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:splatvalue=>
          {:@line=>1,
           :@value=>
            {:arrayliteral=>
              {:@body=>
                [{:arrayliteral=>
                   {:@body=>
                     [{:arrayliteral=>
                        {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                         :@line=>1}}],
                    :@line=>1}}],
               :@line=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b, * = c"' do
    ruby = 'a, b, * = c'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:toarray=>
          {:@line=>1,
           :@value=>
            {:send=>
              {:@block=>nil,
               :@name=>:c,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b, = c"' do
    ruby = 'a, b, = c'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:toarray=>
          {:@line=>1,
           :@value=>
            {:send=>
              {:@block=>nil,
               :@name=>:c,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b, c = m d"' do
    ruby = 'a, b, c = m d'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:toarray=>
          {:@line=>1,
           :@value=>
            {:sendwitharguments=>
              {:@block=>nil,
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
                        :@name=>:d,
                        :@line=>1,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>1}},
                        :@check_for_local=>false}}],
                   :@splat=>nil,
                   :@line=>1}}}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b, *c = d, e, f, g"' do
    ruby = 'a, b, *c = d, e, f, g'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>
        {:splatassignment=>
          {:@line=>1,
           :@value=>
            {:localvariableassignment=>
              {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}}},
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:send=>
               {:@block=>nil,
                :@name=>:d,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}},
             {:send=>
               {:@block=>nil,
                :@name=>:e,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}},
             {:send=>
               {:@block=>nil,
                :@name=>:f,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}},
             {:send=>
               {:@block=>nil,
                :@name=>:g,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b, *c = d.e("f")"' do
    ruby = 'a, b, *c = d.e("f")'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>
        {:splatassignment=>
          {:@line=>1,
           :@value=>
            {:localvariableassignment=>
              {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}}},
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:toarray=>
          {:@line=>1,
           :@value=>
            {:sendwitharguments=>
              {:@block=>nil,
               :@name=>:e,
               :@line=>1,
               :@privately=>false,
               :@receiver=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:d,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>[{:stringliteral=>{:@string=>:f, :@line=>1}}],
                   :@splat=>nil,
                   :@line=>1}}}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b, *c = d"' do
    ruby = 'a, b, *c = d'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>
        {:splatassignment=>
          {:@line=>1,
           :@value=>
            {:localvariableassignment=>
              {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}}},
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:toarray=>
          {:@line=>1,
           :@value=>
            {:send=>
              {:@block=>nil,
               :@name=>:d,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, b = c"' do
    ruby = 'a, b = c'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:toarray=>
          {:@line=>1,
           :@value=>
            {:send=>
              {:@block=>nil,
               :@name=>:c,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m do ..."' do
    ruby = <<-ruby
        m do
          a, b = 1, 2
          next
        end
      ruby
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:masgn=>
                   {:@block=>nil,
                    :@fixed=>true,
                    :@splat=>nil,
                    :@line=>2,
                    :@left=>
                     {:arrayliteral=>
                       {:@body=>
                         [{:localvariableassignment=>
                            {:@variable=>nil,
                             :@name=>:a,
                             :@line=>2,
                             :@value=>nil}},
                          {:localvariableassignment=>
                            {:@variable=>nil,
                             :@name=>:b,
                             :@line=>2,
                             :@value=>nil}}],
                        :@line=>2}},
                    :@right=>
                     {:arrayliteral=>
                       {:@body=>
                         [{:fixnumliteral=>{:@line=>2, :@value=>1}},
                          {:fixnumliteral=>{:@line=>2, :@value=>2}}],
                        :@line=>2}}}},
                 {:next=>{:@line=>3, :@value=>nil}}],
               :@line=>2}},
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

  it 'should correctly parse "a, (b, c) = 1"' do
    ruby = 'a, (b, c) = 1'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:masgn=>
               {:@block=>nil,
                :@fixed=>false,
                :@splat=>nil,
                :@line=>1,
                :@left=>
                 {:arrayliteral=>
                   {:@body=>
                     [{:localvariableassignment=>
                        {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}},
                      {:localvariableassignment=>
                        {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}],
                    :@line=>1}},
                :@right=>nil}}],
           :@line=>1}},
       :@right=>
        {:toarray=>
          {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, (b, c) = *1"' do
    ruby = 'a, (b, c) = *1'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:masgn=>
               {:@block=>nil,
                :@fixed=>false,
                :@splat=>nil,
                :@line=>1,
                :@left=>
                 {:arrayliteral=>
                   {:@body=>
                     [{:localvariableassignment=>
                        {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}},
                      {:localvariableassignment=>
                        {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}],
                    :@line=>1}},
                :@right=>nil}}],
           :@line=>1}},
       :@right=>
        {:splatvalue=>
          {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, (b, c) = 1, 2, 3"' do
    ruby = 'a, (b, c) = 1, 2, 3'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:masgn=>
               {:@block=>nil,
                :@fixed=>false,
                :@splat=>nil,
                :@line=>1,
                :@left=>
                 {:arrayliteral=>
                   {:@body=>
                     [{:localvariableassignment=>
                        {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}},
                      {:localvariableassignment=>
                        {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}],
                    :@line=>1}},
                :@right=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}},
             {:fixnumliteral=>{:@line=>1, :@value=>3}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, (b, *c), d = 1, 2, 3, 4"' do
    ruby = 'a, (b, *c), d = 1, 2, 3, 4'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:masgn=>
               {:@block=>nil,
                :@fixed=>false,
                :@splat=>
                 {:splatwrapped=>
                   {:@line=>1,
                    :@value=>
                     {:localvariableassignment=>
                       {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}}},
                :@line=>1,
                :@left=>
                 {:arrayliteral=>
                   {:@body=>
                     [{:localvariableassignment=>
                        {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
                    :@line=>1}},
                :@right=>nil}},
             {:localvariableassignment=>
               {:@variable=>nil, :@name=>:d, :@line=>1, :@value=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}},
             {:fixnumliteral=>{:@line=>1, :@value=>3}},
             {:fixnumliteral=>{:@line=>1, :@value=>4}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, (b, c) = 1, *2"' do
    ruby = 'a, (b, c) = 1, *2'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:masgn=>
               {:@block=>nil,
                :@fixed=>false,
                :@splat=>nil,
                :@line=>1,
                :@left=>
                 {:arrayliteral=>
                   {:@body=>
                     [{:localvariableassignment=>
                        {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}},
                      {:localvariableassignment=>
                        {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}],
                    :@line=>1}},
                :@right=>nil}}],
           :@line=>1}},
       :@right=>
        {:concatargs=>
          {:@array=>
            {:arrayliteral=>
              {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}], :@line=>1}},
           :@size=>1,
           :@rest=>{:fixnumliteral=>{:@line=>1, :@value=>2}},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, (b, *c) = 1"' do
    ruby = 'a, (b, *c) = 1'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:masgn=>
               {:@block=>nil,
                :@fixed=>false,
                :@splat=>
                 {:splatwrapped=>
                   {:@line=>1,
                    :@value=>
                     {:localvariableassignment=>
                       {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}}},
                :@line=>1,
                :@left=>
                 {:arrayliteral=>
                   {:@body=>
                     [{:localvariableassignment=>
                        {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
                    :@line=>1}},
                :@right=>nil}}],
           :@line=>1}},
       :@right=>
        {:toarray=>
          {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, (b, *c) = 1, 2"' do
    ruby = 'a, (b, *c) = 1, 2'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:masgn=>
               {:@block=>nil,
                :@fixed=>false,
                :@splat=>
                 {:splatwrapped=>
                   {:@line=>1,
                    :@value=>
                     {:localvariableassignment=>
                       {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}}},
                :@line=>1,
                :@left=>
                 {:arrayliteral=>
                   {:@body=>
                     [{:localvariableassignment=>
                        {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
                    :@line=>1}},
                :@right=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, (b, *c) = *1"' do
    ruby = 'a, (b, *c) = *1'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:masgn=>
               {:@block=>nil,
                :@fixed=>false,
                :@splat=>
                 {:splatwrapped=>
                   {:@line=>1,
                    :@value=>
                     {:localvariableassignment=>
                       {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}}},
                :@line=>1,
                :@left=>
                 {:arrayliteral=>
                   {:@body=>
                     [{:localvariableassignment=>
                        {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
                    :@line=>1}},
                :@right=>nil}}],
           :@line=>1}},
       :@right=>
        {:splatvalue=>
          {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, (b, *c) = 1, *2"' do
    ruby = 'a, (b, *c) = 1, *2'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:masgn=>
               {:@block=>nil,
                :@fixed=>false,
                :@splat=>
                 {:splatwrapped=>
                   {:@line=>1,
                    :@value=>
                     {:localvariableassignment=>
                       {:@variable=>nil, :@name=>:c, :@line=>1, :@value=>nil}}}},
                :@line=>1,
                :@left=>
                 {:arrayliteral=>
                   {:@body=>
                     [{:localvariableassignment=>
                        {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}],
                    :@line=>1}},
                :@right=>nil}}],
           :@line=>1}},
       :@right=>
        {:concatargs=>
          {:@array=>
            {:arrayliteral=>
              {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}], :@line=>1}},
           :@size=>1,
           :@rest=>{:fixnumliteral=>{:@line=>1, :@value=>2}},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, (*b) = 1"' do
    ruby = 'a, (*b) = 1'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:masgn=>
               {:@block=>nil,
                :@fixed=>false,
                :@splat=>
                 {:splatwrapped=>
                   {:@line=>1,
                    :@value=>
                     {:localvariableassignment=>
                       {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}}},
                :@line=>1,
                :@left=>nil,
                :@right=>nil}}],
           :@line=>1}},
       :@right=>
        {:toarray=>
          {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, (*b) = 1, 2"' do
    ruby = 'a, (*b) = 1, 2'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>true,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:masgn=>
               {:@block=>nil,
                :@fixed=>false,
                :@splat=>
                 {:splatwrapped=>
                   {:@line=>1,
                    :@value=>
                     {:localvariableassignment=>
                       {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}}},
                :@line=>1,
                :@left=>nil,
                :@right=>nil}}],
           :@line=>1}},
       :@right=>
        {:arrayliteral=>
          {:@body=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, (*b) = *1"' do
    ruby = 'a, (*b) = *1'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:masgn=>
               {:@block=>nil,
                :@fixed=>false,
                :@splat=>
                 {:splatwrapped=>
                   {:@line=>1,
                    :@value=>
                     {:localvariableassignment=>
                       {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}}},
                :@line=>1,
                :@left=>nil,
                :@right=>nil}}],
           :@line=>1}},
       :@right=>
        {:splatvalue=>
          {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a, (*b) = 1, *2"' do
    ruby = 'a, (*b) = 1, *2'
    ast  = {:masgn=>
      {:@block=>nil,
       :@fixed=>false,
       :@splat=>nil,
       :@line=>1,
       :@left=>
        {:arrayliteral=>
          {:@body=>
            [{:localvariableassignment=>
               {:@variable=>nil, :@name=>:a, :@line=>1, :@value=>nil}},
             {:masgn=>
               {:@block=>nil,
                :@fixed=>false,
                :@splat=>
                 {:splatwrapped=>
                   {:@line=>1,
                    :@value=>
                     {:localvariableassignment=>
                       {:@variable=>nil, :@name=>:b, :@line=>1, :@value=>nil}}}},
                :@line=>1,
                :@left=>nil,
                :@right=>nil}}],
           :@line=>1}},
       :@right=>
        {:concatargs=>
          {:@array=>
            {:arrayliteral=>
              {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}], :@line=>1}},
           :@size=>1,
           :@rest=>{:fixnumliteral=>{:@line=>1, :@value=>2}},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

end
