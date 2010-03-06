require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "y = 0; 42.method = y"' do
    ruby = 'y = 0; 42.method = y'
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:y,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>0}}}},
         {:attributeassignment=>
           {:@name=>:method=,
            :@line=>1,
            :@privately=>false,
            :@receiver=>{:fixnumliteral=>{:@line=>1, :@value=>42}},
            :@arguments=>
             {:actualarguments=>
               {:@array=>
                 [{:localvariableaccess=>
                    {:@variable=>nil, :@name=>:y, :@line=>1}}],
                :@splat=>nil,
                :@line=>1}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a.m = *[1]"' do
    ruby = 'a.m = *[1]'
    ast  = {:attributeassignment=>
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
        {:actualarguments=>
          {:@array=>
            [{:svalue=>
               {:@line=>1,
                :@value=>
                 {:splatvalue=>
                   {:@line=>1,
                    :@value=>
                     {:arrayliteral=>
                       {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                        :@line=>1}}}}}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a[*b] = c"' do
    ruby = 'a[*b] = c'
    ast  = {:elementassignment=>
      {:@name=>:[]=,
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
        {:pushargs=>
          {:@line=>1,
           :@value=>
            {:send=>
              {:@block=>nil,
               :@name=>:c,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@arguments=>
            {:splatvalue=>
              {:@line=>1,
               :@value=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:b,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}}}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a[b, *c] = d"' do
    ruby = 'a[b, *c] = d'
    ast  = {:elementassignment=>
      {:@name=>:[]=,
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
        {:pushargs=>
          {:@line=>1,
           :@value=>
            {:send=>
              {:@block=>nil,
               :@name=>:d,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@arguments=>
            {:concatargs=>
              {:@array=>
                {:arrayliteral=>
                  {:@body=>
                    [{:send=>
                       {:@block=>nil,
                        :@name=>:b,
                        :@line=>1,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>1}},
                        :@check_for_local=>false}}],
                   :@line=>1}},
               :@size=>1,
               :@rest=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:c,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}},
               :@line=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a[b, *c] = *d"' do
    ruby = 'a[b, *c] = *d'
    ast  = {:elementassignment=>
      {:@name=>:[]=,
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
        {:pushargs=>
          {:@line=>1,
           :@value=>
            {:svalue=>
              {:@line=>1,
               :@value=>
                {:splatvalue=>
                  {:@line=>1,
                   :@value=>
                    {:send=>
                      {:@block=>nil,
                       :@name=>:d,
                       :@line=>1,
                       :@privately=>true,
                       :@receiver=>{:self=>{:@line=>1}},
                       :@check_for_local=>false}}}}}},
           :@arguments=>
            {:concatargs=>
              {:@array=>
                {:arrayliteral=>
                  {:@body=>
                    [{:send=>
                       {:@block=>nil,
                        :@name=>:b,
                        :@line=>1,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>1}},
                        :@check_for_local=>false}}],
                   :@line=>1}},
               :@size=>1,
               :@rest=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:c,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}},
               :@line=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a[b, *c] = *d"' do
    ruby = 'a[b, *c] = *d'
    ast  = {:elementassignment=>
      {:@name=>:[]=,
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
        {:pushargs=>
          {:@line=>1,
           :@value=>
            {:svalue=>
              {:@line=>1,
               :@value=>
                {:splatvalue=>
                  {:@line=>1,
                   :@value=>
                    {:send=>
                      {:@block=>nil,
                       :@name=>:d,
                       :@line=>1,
                       :@privately=>true,
                       :@receiver=>{:self=>{:@line=>1}},
                       :@check_for_local=>false}}}}}},
           :@arguments=>
            {:concatargs=>
              {:@array=>
                {:arrayliteral=>
                  {:@body=>
                    [{:send=>
                       {:@block=>nil,
                        :@name=>:b,
                        :@line=>1,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>1}},
                        :@check_for_local=>false}}],
                   :@line=>1}},
               :@size=>1,
               :@rest=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:c,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}},
               :@line=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a[42] = 24"' do
    ruby = 'a[42] = 24'
    ast  = {:elementassignment=>
      {:@name=>:[]=,
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
        {:actualarguments=>
          {:@array=>
            [{:fixnumliteral=>{:@line=>1, :@value=>42}},
             {:fixnumliteral=>{:@line=>1, :@value=>24}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "self[index, 0] = other_string"' do
    ruby = 'self[index, 0] = other_string'
    ast  = {:elementassignment=>
      {:@name=>:[]=,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:send=>
               {:@block=>nil,
                :@name=>:index,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}},
             {:fixnumliteral=>{:@line=>1, :@value=>0}},
             {:send=>
               {:@block=>nil,
                :@name=>:other_string,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = []; a [42] = 24"' do
    ruby = <<-ruby
        a = []
        a [42] = 24
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:emptyarray=>{:@line=>1}}}},
         {:elementassignment=>
           {:@name=>:[]=,
            :@line=>2,
            :@privately=>false,
            :@receiver=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
            :@arguments=>
             {:actualarguments=>
               {:@array=>
                 [{:fixnumliteral=>{:@line=>2, :@value=>42}},
                  {:fixnumliteral=>{:@line=>2, :@value=>24}}],
                :@splat=>nil,
                :@line=>2}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m { |a.b| }"' do
    ruby = <<-ruby
        m { |a.b| }
      ruby
    ast  = {:send=>
      {:@block=>
        {:iter=>
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
                {:attributeassignment=>
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
                    {:actualarguments=>
                      {:@array=>[], :@splat=>nil, :@line=>1}}}}}}}},
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

end
