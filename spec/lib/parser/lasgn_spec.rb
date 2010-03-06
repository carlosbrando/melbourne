require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "a = 1"' do
    ruby = 'a = 1'
    ast  = {:localvariableassignment=>
      {:@variable=>nil,
       :@name=>:a,
       :@line=>1,
       :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = b, c, *d"' do
    ruby = 'a = b, c, *d'
    ast  = {:localvariableassignment=>
      {:@variable=>nil,
       :@name=>:a,
       :@line=>1,
       :@value=>
        {:svalue=>
          {:@line=>1,
           :@value=>
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
                        :@check_for_local=>false}},
                     {:send=>
                       {:@block=>nil,
                        :@name=>:c,
                        :@line=>1,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>1}},
                        :@check_for_local=>false}}],
                   :@line=>1}},
               :@size=>2,
               :@rest=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:d,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}},
               :@line=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = [b, *c]"' do
    ruby = 'a = [b, *c]'
    ast  = {:localvariableassignment=>
      {:@variable=>nil,
       :@name=>:a,
       :@line=>1,
       :@value=>
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
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "x = (y = 1(y + 2))"' do
    ruby = <<-ruby
        x = (y = 1
             (y + 2))
      ruby
    ast  = {:localvariableassignment=>
      {:@variable=>nil,
       :@name=>:x,
       :@line=>1,
       :@value=>
        {:block=>
          {:@array=>
            [{:localvariableassignment=>
               {:@variable=>nil,
                :@name=>:y,
                :@line=>1,
                :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
             {:sendwitharguments=>
               {:@block=>nil,
                :@name=>:+,
                :@line=>2,
                :@privately=>false,
                :@receiver=>
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:y, :@line=>2}},
                :@check_for_local=>false,
                :@arguments=>
                 {:actualarguments=>
                   {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>2}}],
                    :@splat=>nil,
                    :@line=>2}}}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = []; a [42]"' do
    ruby = <<-ruby
        a = []
        a [42]
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:emptyarray=>{:@line=>1}}}},
         {:sendwitharguments=>
           {:@block=>nil,
            :@name=>:[],
            :@line=>2,
            :@privately=>false,
            :@receiver=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
            :@check_for_local=>false,
            :@arguments=>
             {:actualarguments=>
               {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>42}}],
                :@splat=>nil,
                :@line=>2}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "var = ["foo", "bar"]"' do
    ruby = 'var = ["foo", "bar"]'
    ast  = {:localvariableassignment=>
      {:@variable=>nil,
       :@name=>:var,
       :@line=>1,
       :@value=>
        {:arrayliteral=>
          {:@body=>
            [{:stringliteral=>{:@string=>:foo, :@line=>1}},
             {:stringliteral=>{:@string=>:bar, :@line=>1}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "c = (2 + 3)"' do
    ruby = 'c = (2 + 3)'
    ast  = {:localvariableassignment=>
      {:@variable=>nil,
       :@name=>:c,
       :@line=>1,
       :@value=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:+,
           :@line=>1,
           :@privately=>false,
           :@receiver=>{:fixnumliteral=>{:@line=>1, :@value=>2}},
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>3}}],
               :@splat=>nil,
               :@line=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = *[1]"' do
    ruby = 'a = *[1]'
    ast  = {:localvariableassignment=>
      {:@variable=>nil,
       :@name=>:a,
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
                   :@line=>1}}}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = *b"' do
    ruby = 'a = *b'
    ast  = {:localvariableassignment=>
      {:@variable=>nil,
       :@name=>:a,
       :@line=>1,
       :@value=>
        {:svalue=>
          {:@line=>1,
           :@value=>
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

  it 'should correctly parse "a = if ..."' do
    ruby = <<-ruby
        a = if c
              begin
                b
              rescue
                nil
              end
            end
        a
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>
             {:if=>
               {:@body=>
                 {:rescue=>
                   {:@body=>
                     {:send=>
                       {:@block=>nil,
                        :@name=>:b,
                        :@line=>3,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>3}},
                        :@check_for_local=>false}},
                    :@rescue=>
                     {:rescuecondition=>
                       {:@conditions=>
                         {:arrayliteral=>
                           {:@body=>
                             [{:constfind=>{:@name=>:StandardError, :@line=>5}}],
                            :@line=>5}},
                        :@body=>{},
                        :@splat=>nil,
                        :@next=>nil,
                        :@line=>5,
                        :@assignment=>nil}},
                    :@else=>nil,
                    :@line=>3}},
                :@condition=>
                 {:send=>
                   {:@block=>nil,
                    :@name=>:c,
                    :@line=>1,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>1}},
                    :@check_for_local=>false}},
                :@else=>{},
                :@line=>1}}}},
         {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>8}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "x = [*[1]]"' do
    ruby = 'x = [*[1]]'
    ast  = {:localvariableassignment=>
      {:@variable=>nil,
       :@name=>:x,
       :@line=>1,
       :@value=>
        {:splatvalue=>
          {:@line=>1,
           :@value=>
            {:arrayliteral=>
              {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}], :@line=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = []"' do
    ruby = 'a = []'
    ast  = {:localvariableassignment=>
      {:@variable=>nil,
       :@name=>:a,
       :@line=>1,
       :@value=>{:emptyarray=>{:@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = 12; a"' do
    ruby = <<-ruby
        a = 12
        a
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>12}}}},
         {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "name; name = 3; name"' do
    ruby = <<-ruby
        name
        name = 3
        name
      ruby
    ast  = {:block=>
      {:@array=>
        [{:send=>
           {:@block=>nil,
            :@name=>:name,
            :@line=>1,
            :@privately=>true,
            :@receiver=>{:self=>{:@line=>1}},
            :@check_for_local=>false}},
         {:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:name,
            :@line=>2,
            :@value=>{:fixnumliteral=>{:@line=>2, :@value=>3}}}},
         {:localvariableaccess=>{:@variable=>nil, :@name=>:name, :@line=>3}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a=12; b=13; true"' do
    ruby = 'a=12; b=13; true'
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>12}}}},
         {:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:b,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>13}}}},
         {:true=>{:@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f; a = 1; end"' do
    ruby = <<-ruby
        def f
          a = 1
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:localvariableassignment=>
               {:@variable=>nil,
                :@name=>:a,
                :@line=>2,
                :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}}],
           :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(a); a = 1; end"' do
    ruby = <<-ruby
        def f(a)
          a = 1
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:localvariableassignment=>
               {:@variable=>nil,
                :@name=>:a,
                :@line=>2,
                :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}}],
           :@line=>1}},
       :@name=>:f,
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

  it 'should correctly parse "def f; b { a = 1 }; end"' do
    ruby = <<-ruby
        def f
          b { a = 1 }
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:send=>
               {:@block=>
                 {:iter=>
                   {:@body=>
                     {:localvariableassignment=>
                       {:@variable=>nil,
                        :@name=>:a,
                        :@line=>2,
                        :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}},
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
                :@name=>:b,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false}}],
           :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(a); b { a = 2 }; end"' do
    ruby = <<-ruby
        def f(a)
          b { a = 2 }
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:send=>
               {:@block=>
                 {:iter=>
                   {:@body=>
                     {:localvariableassignment=>
                       {:@variable=>nil,
                        :@name=>:a,
                        :@line=>2,
                        :@value=>{:fixnumliteral=>{:@line=>2, :@value=>2}}}},
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
                :@name=>:b,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false}}],
           :@line=>1}},
       :@name=>:f,
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

  it 'should correctly parse "def f; a = 1; b { a = 2 }; end"' do
    ruby = <<-ruby
        def f
          a = 1
          b { a = 2 }
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:localvariableassignment=>
               {:@variable=>nil,
                :@name=>:a,
                :@line=>2,
                :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}},
             {:send=>
               {:@block=>
                 {:iter=>
                   {:@body=>
                     {:localvariableassignment=>
                       {:@variable=>nil,
                        :@name=>:a,
                        :@line=>3,
                        :@value=>{:fixnumliteral=>{:@line=>3, :@value=>2}}}},
                    :@line=>3,
                    :@arguments=>
                     {:iterarguments=>
                       {:@block=>nil,
                        :@arity=>-1,
                        :@prelude=>nil,
                        :@optional=>0,
                        :@splat=>nil,
                        :@line=>3,
                        :@splat_index=>-2,
                        :@required_args=>0}}}},
                :@name=>:b,
                :@line=>3,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>3}},
                :@check_for_local=>false}}],
           :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f; a; b { a = 1 }; end"' do
    ruby = <<-ruby
        def f
          a
          b { a = 1 }
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:send=>
               {:@block=>nil,
                :@name=>:a,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false}},
             {:send=>
               {:@block=>
                 {:iter=>
                   {:@body=>
                     {:localvariableassignment=>
                       {:@variable=>nil,
                        :@name=>:a,
                        :@line=>3,
                        :@value=>{:fixnumliteral=>{:@line=>3, :@value=>1}}}},
                    :@line=>3,
                    :@arguments=>
                     {:iterarguments=>
                       {:@block=>nil,
                        :@arity=>-1,
                        :@prelude=>nil,
                        :@optional=>0,
                        :@splat=>nil,
                        :@line=>3,
                        :@splat_index=>-2,
                        :@required_args=>0}}}},
                :@name=>:b,
                :@line=>3,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>3}},
                :@check_for_local=>false}}],
           :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f; b { a = 1 }; a; end"' do
    ruby = <<-ruby
        def f
          b { a = 1 }
          a
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:send=>
               {:@block=>
                 {:iter=>
                   {:@body=>
                     {:localvariableassignment=>
                       {:@variable=>nil,
                        :@name=>:a,
                        :@line=>2,
                        :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}},
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
                :@name=>:b,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false}},
             {:send=>
               {:@block=>nil,
                :@name=>:a,
                :@line=>3,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>3}},
                :@check_for_local=>false}}],
           :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f; a = 1; b { a = 2 }; a; end"' do
    ruby = <<-ruby
        def f
          a = 1
          b { a = 2 }
          a
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:localvariableassignment=>
               {:@variable=>nil,
                :@name=>:a,
                :@line=>2,
                :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}},
             {:send=>
               {:@block=>
                 {:iter=>
                   {:@body=>
                     {:localvariableassignment=>
                       {:@variable=>nil,
                        :@name=>:a,
                        :@line=>3,
                        :@value=>{:fixnumliteral=>{:@line=>3, :@value=>2}}}},
                    :@line=>3,
                    :@arguments=>
                     {:iterarguments=>
                       {:@block=>nil,
                        :@arity=>-1,
                        :@prelude=>nil,
                        :@optional=>0,
                        :@splat=>nil,
                        :@line=>3,
                        :@splat_index=>-2,
                        :@required_args=>0}}}},
                :@name=>:b,
                :@line=>3,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>3}},
                :@check_for_local=>false}},
             {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>4}}],
           :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "class F; a = 1; end"' do
    ruby = <<-ruby
        class F
          a = 1
        end
      ruby
    ast  = {:class=>
      {:@superclass=>{},
       :@body=>
        {:classscope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:a,
                    :@line=>2,
                    :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}}],
               :@line=>3}},
           :@name=>:F,
           :@line=>1}},
       :@name=>{:classname=>{:@superclass=>{}, :@name=>:F, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = Object; class a::F; b = 1; end"' do
    ruby = <<-ruby
        a = Object
        class a::F
          b = 1
        end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:constfind=>{:@name=>:Object, :@line=>1}}}},
         {:class=>
           {:@superclass=>{},
            :@body=>
             {:classscope=>
               {:@body=>
                 {:block=>
                   {:@array=>
                     [{:localvariableassignment=>
                        {:@variable=>nil,
                         :@name=>:b,
                         :@line=>3,
                         :@value=>{:fixnumliteral=>{:@line=>3, :@value=>1}}}}],
                    :@line=>4}},
                :@name=>:F,
                :@line=>2}},
            :@name=>
             {:scopedclassname=>
               {:@superclass=>{},
                :@parent=>
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
                :@name=>:F,
                :@line=>2}},
            :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = Object; class F < a; b = 1; end"' do
    ruby = <<-ruby
        a = Object
        class F < a
          b = 1
        end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:constfind=>{:@name=>:Object, :@line=>1}}}},
         {:class=>
           {:@superclass=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
            :@body=>
             {:classscope=>
               {:@body=>
                 {:block=>
                   {:@array=>
                     [{:localvariableassignment=>
                        {:@variable=>nil,
                         :@name=>:b,
                         :@line=>3,
                         :@value=>{:fixnumliteral=>{:@line=>3, :@value=>1}}}}],
                    :@line=>4}},
                :@name=>:F,
                :@line=>2}},
            :@name=>
             {:classname=>
               {:@superclass=>
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
                :@name=>:F,
                :@line=>2}},
            :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "class F; a = 1; def f ..."' do
    ruby = <<-ruby
        class F
          a = 1
          def f
            a = 1
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
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:a,
                    :@line=>2,
                    :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}},
                 {:define=>
                   {:@body=>
                     {:block=>
                       {:@array=>
                         [{:localvariableassignment=>
                            {:@variable=>nil,
                             :@name=>:a,
                             :@line=>4,
                             :@value=>{:fixnumliteral=>{:@line=>4, :@value=>1}}}}],
                        :@line=>3}},
                    :@name=>:f,
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
           :@name=>:F,
           :@line=>1}},
       :@name=>{:classname=>{:@superclass=>{}, :@name=>:F, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "module M; a = 1; end"' do
    ruby = <<-ruby
        module M
          a = 1
        end
      ruby
    ast  = {:module=>
      {:@body=>
        {:modulescope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:a,
                    :@line=>2,
                    :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}}],
               :@line=>3}},
           :@name=>:M,
           :@line=>1}},
       :@name=>{:modulename=>{:@name=>:M, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "module M; a = 1; def f ..."' do
    ruby = <<-ruby
        module M
          a = 1
          def f
            a = 1
          end
        end
      ruby
    ast  = {:module=>
      {:@body=>
        {:modulescope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:a,
                    :@line=>2,
                    :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}},
                 {:define=>
                   {:@body=>
                     {:block=>
                       {:@array=>
                         [{:localvariableassignment=>
                            {:@variable=>nil,
                             :@name=>:a,
                             :@line=>4,
                             :@value=>{:fixnumliteral=>{:@line=>4, :@value=>1}}}}],
                        :@line=>3}},
                    :@name=>:f,
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
           :@name=>:M,
           :@line=>1}},
       :@name=>{:modulename=>{:@name=>:M, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = Object; module a::M; b = 1; end"' do
    ruby = <<-ruby
        a = Object
        module a::M
          b = 1
        end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:constfind=>{:@name=>:Object, :@line=>1}}}},
         {:module=>
           {:@body=>
             {:modulescope=>
               {:@body=>
                 {:block=>
                   {:@array=>
                     [{:localvariableassignment=>
                        {:@variable=>nil,
                         :@name=>:b,
                         :@line=>3,
                         :@value=>{:fixnumliteral=>{:@line=>3, :@value=>1}}}}],
                    :@line=>4}},
                :@name=>:M,
                :@line=>2}},
            :@name=>
             {:scopedmodulename=>
               {:@parent=>
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
                :@name=>:M,
                :@line=>2}},
            :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
