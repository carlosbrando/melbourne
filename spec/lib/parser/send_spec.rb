require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "def ... begin ... end"' do
    ruby = <<-ruby
        def m
          begin
          end
        end
      ruby
    ast  = {:define=>
      {:@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}},
       :@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:m,
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def ... ensure ..."' do
    ruby = <<-ruby
        def m
          return :a
        ensure
          return :b
        end
      ruby
    ast  = {:define=>
      {:@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}},
       :@body=>
        {:block=>
          {:@array=>
            [{:ensure=>
               {:@ensure=>
                 {:return=>
                   {:@splat=>nil,
                    :@line=>4,
                    :@value=>{:symbolliteral=>{:@line=>4, :@value=>:b}}}},
                :@body=>
                 {:return=>
                   {:@splat=>nil,
                    :@line=>2,
                    :@value=>{:symbolliteral=>{:@line=>2, :@value=>:a}}}},
                :@line=>2}}],
           :@line=>1}},
       :@name=>:m,
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def blah(*args, &block) ..."' do
    ruby = <<-ruby
        def blah(*args, &block)
          other(42, *args, &block)
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:sendwitharguments=>
               {:@block=>
                 {:blockpass=>
                   {:@body=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:block, :@line=>2}},
                    :@line=>2}},
                :@name=>:other,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false,
                :@arguments=>
                 {:actualarguments=>
                   {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>42}}],
                    :@splat=>
                     {:splatvalue=>
                       {:@line=>2,
                        :@value=>
                         {:localvariableaccess=>
                           {:@variable=>nil, :@name=>:args, :@line=>2}}}},
                    :@line=>2}}}}],
           :@line=>1}},
       :@name=>:blah,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>{:blockargument=>{:@name=>:block, :@line=>1}},
           :@names=>[:args, :block],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>:args,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f ... begin ... rescue ... end ... d ..."' do
    ruby = <<-ruby
        def f
          begin
            b
          rescue
            c
          end
          d
        end
      ruby
    ast  = {:define=>
      {:@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}},
       :@body=>
        {:block=>
          {:@array=>
            [{:begin=>
               {:@rescue=>
                 {:rescue=>
                   {:@body=>
                     {:send=>
                       {:@receiver=>{:self=>{:@line=>3}},
                        :@check_for_local=>false,
                        :@block=>nil,
                        :@name=>:b,
                        :@line=>3,
                        :@privately=>true}},
                    :@rescue=>
                     {:rescuecondition=>
                       {:@assignment=>nil,
                        :@conditions=>
                         {:arrayliteral=>
                           {:@body=>
                             [{:constfind=>{:@name=>:StandardError, :@line=>5}}],
                            :@line=>5}},
                        :@body=>
                         {:send=>
                           {:@receiver=>{:self=>{:@line=>5}},
                            :@check_for_local=>false,
                            :@block=>nil,
                            :@name=>:c,
                            :@line=>5,
                            :@privately=>true}},
                        :@splat=>nil,
                        :@next=>nil,
                        :@line=>5}},
                    :@else=>nil,
                    :@line=>3}},
                :@line=>2}},
             {:send=>
               {:@receiver=>{:self=>{:@line=>7}},
                :@check_for_local=>false,
                :@block=>nil,
                :@name=>:d,
                :@line=>7,
                :@privately=>true}}],
           :@line=>1}},
       :@name=>:f,
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f ... a ... begin ... rescue ... end ..."' do
    ruby = <<-ruby
        def f
          a
          begin
            b
          rescue
            c
          end
        end
      ruby
    ast  = {:define=>
      {:@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}},
       :@body=>
        {:block=>
          {:@array=>
            [{:send=>
               {:@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false,
                :@block=>nil,
                :@name=>:a,
                :@line=>2,
                :@privately=>true}},
             {:begin=>
               {:@rescue=>
                 {:rescue=>
                   {:@body=>
                     {:send=>
                       {:@receiver=>{:self=>{:@line=>4}},
                        :@check_for_local=>false,
                        :@block=>nil,
                        :@name=>:b,
                        :@line=>4,
                        :@privately=>true}},
                    :@rescue=>
                     {:rescuecondition=>
                       {:@assignment=>nil,
                        :@conditions=>
                         {:arrayliteral=>
                           {:@body=>
                             [{:constfind=>{:@name=>:StandardError, :@line=>6}}],
                            :@line=>6}},
                        :@body=>
                         {:send=>
                           {:@receiver=>{:self=>{:@line=>6}},
                            :@check_for_local=>false,
                            :@block=>nil,
                            :@name=>:c,
                            :@line=>6,
                            :@privately=>true}},
                        :@splat=>nil,
                        :@next=>nil,
                        :@line=>6}},
                    :@else=>nil,
                    :@line=>4}},
                :@line=>3}}],
           :@line=>1}},
       :@name=>:f,
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f ... a begin ... rescue ... end ... d ..."' do
    ruby = <<-ruby
        def f
          a
          begin
            b
          rescue
            c
          end
          d
        end
      ruby
    ast  = {:define=>
      {:@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}},
       :@body=>
        {:block=>
          {:@array=>
            [{:send=>
               {:@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false,
                :@block=>nil,
                :@name=>:a,
                :@line=>2,
                :@privately=>true}},
             {:begin=>
               {:@rescue=>
                 {:rescue=>
                   {:@body=>
                     {:send=>
                       {:@receiver=>{:self=>{:@line=>4}},
                        :@check_for_local=>false,
                        :@block=>nil,
                        :@name=>:b,
                        :@line=>4,
                        :@privately=>true}},
                    :@rescue=>
                     {:rescuecondition=>
                       {:@assignment=>nil,
                        :@conditions=>
                         {:arrayliteral=>
                           {:@body=>
                             [{:constfind=>{:@name=>:StandardError, :@line=>6}}],
                          :@line=>6}},
                        :@body=>
                         {:send=>
                           {:@receiver=>{:self=>{:@line=>6}},
                            :@check_for_local=>false,
                            :@block=>nil,
                            :@name=>:c,
                            :@line=>6,
                            :@privately=>true}},
                        :@splat=>nil,
                        :@next=>nil,
                        :@line=>6}},
                    :@else=>nil,
                    :@line=>4}},
                :@line=>3}},
             {:send=>
               {:@receiver=>{:self=>{:@line=>8}},
                :@check_for_local=>false,
                :@block=>nil,
                :@name=>:d,
                :@line=>8,
                :@privately=>true}}],
           :@line=>1}},
       :@name=>:f,
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(&block); end"' do
    ruby = <<-ruby
        def f(&block)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>{:blockargument=>{:@name=>:block, :@line=>1}},
           :@names=>[:block],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(mand, opt = 42, &block); end"' do
    ruby = <<-ruby
        def f(mand, opt = 42, &block)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>{:blockargument=>{:@name=>:block, :@line=>1}},
           :@names=>[:mand, :opt, :block],
           :@defaults=>
            {:defaultarguments=>
              {:@names=>[:opt],
               :@line=>1,
               :@arguments=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:opt,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>42}}}}]}},
           :@optional=>[:opt],
           :@splat=>nil,
           :@line=>1,
           :@required=>[:mand]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(x, a=x.b); end"' do
    ruby = <<-ruby
        def f(x, a=x.b)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:x, :a],
           :@defaults=>
            {:defaultarguments=>
              {:@names=>[:a],
               :@line=>1,
               :@arguments=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:a,
                    :@line=>1,
                    :@value=>
                     {:send=>
                       {:@block=>nil,
                        :@name=>:b,
                        :@line=>1,
                        :@privately=>false,
                        :@receiver=>
                         {:localvariableaccess=>
                           {:@variable=>nil, :@name=>:x, :@line=>1}},
                        :@check_for_local=>false}}}}]}},
           :@optional=>[:a],
           :@splat=>nil,
           :@line=>1,
           :@required=>[:x]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(mand, &block); end"' do
    ruby = <<-ruby
        def f(mand, &block)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>{:blockargument=>{:@name=>:block, :@line=>1}},
           :@names=>[:mand, :block],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[:mand]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(mand, opt = 42); end"' do
    ruby = <<-ruby
        def f(mand, opt = 42)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:mand, :opt],
           :@defaults=>
            {:defaultarguments=>
              {:@names=>[:opt],
               :@line=>1,
               :@arguments=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:opt,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>42}}}}]}},
           :@optional=>[:opt],
           :@splat=>nil,
           :@line=>1,
           :@required=>[:mand]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(mand, opt = 42, *rest, &block); end"' do
    ruby = <<-ruby
        def f(mand, opt = 42, *rest, &block)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>{:blockargument=>{:@name=>:block, :@line=>1}},
           :@names=>[:mand, :opt, :rest, :block],
           :@defaults=>
            {:defaultarguments=>
              {:@names=>[:opt],
               :@line=>1,
               :@arguments=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:opt,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>42}}}}]}},
           :@optional=>[:opt],
           :@splat=>:rest,
           :@line=>1,
           :@required=>[:mand]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def x(a, b = 42, *); end' do
    ruby = <<-ruby
        def x(a, b = 42, *)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:x,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:a, :b, :@unnamed_splat],
           :@defaults=>
            {:defaultarguments=>
              {:@names=>[:b],
               :@line=>1,
               :@arguments=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:b,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>42}}}}]}},
           :@optional=>[:b],
           :@splat=>:@unnamed_splat,
           :@line=>1,
           :@required=>[:a]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(mand, opt = 42, *rest); end"' do
    ruby = <<-ruby
        def f(mand, opt = 42, *rest)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:mand, :opt, :rest],
           :@defaults=>
            {:defaultarguments=>
              {:@names=>[:opt],
               :@line=>1,
               :@arguments=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:opt,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>42}}}}]}},
           :@optional=>[:opt],
           :@splat=>:rest,
           :@line=>1,
           :@required=>[:mand]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def empty; end"' do
    ruby = <<-ruby
        def empty
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:empty,
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

  it 'should correctly parse "def f(mand); end"' do
    ruby = <<-ruby
        def f(mand)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:mand],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[:mand]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(mand, *rest, &block); end"' do
    ruby = <<-ruby
        def f(mand, *rest, &block)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>{:blockargument=>{:@name=>:block, :@line=>1}},
           :@names=>[:mand, :rest, :block],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>:rest,
           :@line=>1,
           :@required=>[:mand]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def x(a, *args) ..."' do
    ruby = <<-ruby
        def x(a, *args)
          p(a, args)
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:sendwitharguments=>
               {:@block=>nil,
                :@name=>:p,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false,
                :@arguments=>
                 {:actualarguments=>
                   {:@array=>
                     [{:localvariableaccess=>
                        {:@variable=>nil, :@name=>:a, :@line=>2}},
                      {:localvariableaccess=>
                        {:@variable=>nil, :@name=>:args, :@line=>2}}],
                    :@splat=>nil,
                    :@line=>2}}}}],
           :@line=>1}},
       :@name=>:x,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:a, :args],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>:args,
           :@line=>1,
           :@required=>[:a]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(mand, *rest) ..."' do
    ruby = <<-ruby
        def f(mand, *rest)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:mand, :rest],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>:rest,
           :@line=>1,
           :@required=>[:mand]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(opt = 42, &block); end"' do
    ruby = <<-ruby
        def f(opt = 42, &block)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>{:blockargument=>{:@name=>:block, :@line=>1}},
           :@names=>[:opt, :block],
           :@defaults=>
            {:defaultarguments=>
              {:@names=>[:opt],
               :@line=>1,
               :@arguments=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:opt,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>42}}}}]}},
           :@optional=>[:opt],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(a = 42, b = \'1\', c=lambda {|n| n }); end' do
    ruby = <<-ruby
        def f(a = 42, b = '1', c=lambda {|n| n })
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:a, :b, :c],
           :@defaults=>
            {:defaultarguments=>
              {:@names=>[:a, :b, :c],
               :@line=>1,
               :@arguments=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:a,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>42}}}},
                 {:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:b,
                    :@line=>1,
                    :@value=>{:stringliteral=>{:@string=>:"1", :@line=>1}}}},
                 {:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:c,
                    :@line=>1,
                    :@value=>
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
                                :@arity=>1,
                                :@prelude=>:single,
                                :@optional=>0,
                                :@splat=>nil,
                                :@line=>1,
                                :@splat_index=>-1,
                                :@required_args=>1,
                                :@arguments=>
                                 {:localvariableassignment=>
                                   {:@variable=>nil,
                                    :@name=>:n,
                                    :@line=>1,
                                    :@value=>nil}}}}}},
                        :@name=>:lambda,
                        :@line=>1,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>1}},
                        :@check_for_local=>false}}}}]}},
           :@optional=>[:a, :b, :c],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(opt = 42); end"' do
    ruby = <<-ruby
        def f(opt = 42)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:opt],
           :@defaults=>
            {:defaultarguments=>
              {:@names=>[:opt],
               :@line=>1,
               :@arguments=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:opt,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>42}}}}]}},
           :@optional=>[:opt],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(opt = 42, *rest, &block); end"' do
    ruby = <<-ruby
        def f(opt = 42, *rest, &block)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>{:blockargument=>{:@name=>:block, :@line=>1}},
           :@names=>[:opt, :rest, :block],
           :@defaults=>
            {:defaultarguments=>
              {:@names=>[:opt],
               :@line=>1,
               :@arguments=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:opt,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>42}}}}]}},
           :@optional=>[:opt],
           :@splat=>:rest,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def x(b = 42, *); end"' do
    ruby = <<-ruby
        def x(b = 42, *)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:x,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:b, :@unnamed_splat],
           :@defaults=>
            {:defaultarguments=>
              {:@names=>[:b],
               :@line=>1,
               :@arguments=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:b,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>42}}}}]}},
           :@optional=>[:b],
           :@splat=>:@unnamed_splat,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(opt = 42, *rest); end"' do
    ruby = <<-ruby
        def f(opt = 42, *rest)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:opt, :rest],
           :@defaults=>
            {:defaultarguments=>
              {:@names=>[:opt],
               :@line=>1,
               :@arguments=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:opt,
                    :@line=>1,
                    :@value=>{:fixnumliteral=>{:@line=>1, :@value=>42}}}}]}},
           :@optional=>[:opt],
           :@splat=>:rest,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def |(o); end"' do
    ruby = <<-ruby
        def |(o)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:|,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:o],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[:o]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def eql?(resource) ... rescue ..."' do
    ruby = <<-ruby
        def eql?(resource)
          (self.uuid == resource.uuid)
        rescue
          false
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:rescue=>
               {:@body=>
                 {:sendwitharguments=>
                   {:@block=>nil,
                    :@name=>:==,
                    :@line=>2,
                    :@privately=>false,
                    :@receiver=>
                     {:send=>
                       {:@block=>nil,
                        :@name=>:uuid,
                        :@line=>2,
                        :@privately=>false,
                        :@receiver=>{:self=>{:@line=>2}},
                        :@check_for_local=>false}},
                    :@check_for_local=>false,
                    :@arguments=>
                     {:actualarguments=>
                       {:@array=>
                         [{:send=>
                            {:@block=>nil,
                             :@name=>:uuid,
                             :@line=>2,
                             :@privately=>false,
                             :@receiver=>
                              {:localvariableaccess=>
                                {:@variable=>nil, :@name=>:resource, :@line=>2}},
                             :@check_for_local=>false}}],
                        :@splat=>nil,
                        :@line=>2}}}},
                :@rescue=>
                 {:rescuecondition=>
                   {:@conditions=>
                     {:arrayliteral=>
                       {:@body=>
                         [{:constfind=>{:@name=>:StandardError, :@line=>4}}],
                        :@line=>4}},
                    :@body=>{:false=>{:@line=>4}},
                    :@splat=>nil,
                    :@next=>nil,
                    :@line=>4,
                    :@assignment=>nil}},
                :@else=>nil,
                :@line=>2}}],
           :@line=>1}},
       :@name=>:eql?,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:resource],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[:resource]}}}}
    

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def something?; end"' do
    ruby = <<-ruby
        def something?
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:something?,
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

  it 'should correctly parse "def x(*); end"' do
    ruby = <<-ruby
        def x(*)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:x,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:@unnamed_splat],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>:@unnamed_splat,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def f(*rest); end"' do
    ruby = <<-ruby
        def f(*rest)
        end
      ruby
    ast  = {:define=>
      {:@body=>{:block=>{:@array=>[{}], :@line=>1}},
       :@name=>:f,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:rest],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>:rest,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def x(a, *); end"' do
    ruby = <<-ruby
        def x(a, *)
          p(a)
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:sendwitharguments=>
               {:@block=>nil,
                :@name=>:p,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false,
                :@arguments=>
                 {:actualarguments=>
                   {:@array=>
                     [{:localvariableaccess=>
                        {:@variable=>nil, :@name=>:a, :@line=>2}}],
                    :@splat=>nil,
                    :@line=>2}}}}],
           :@line=>1}},
       :@name=>:x,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:a, :@unnamed_splat],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>:@unnamed_splat,
           :@line=>1,
           :@required=>[:a]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def zarray ..."' do
    ruby = <<-ruby
        def zarray
          a = []
          return a
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
                :@value=>{:emptyarray=>{:@line=>2}}}},
             {:return=>
               {:@splat=>nil,
                :@line=>3,
                :@value=>
                 {:localvariableaccess=>
                   {:@variable=>nil, :@name=>:a, :@line=>3}}}}],
           :@line=>1}},
       :@name=>:zarray,
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

  it 'should correctly parse "def a ... begin ... rescue RuntimeError => b ..."' do
    ruby = <<-ruby
        b = 42
        def a
          c do
            begin
              do_stuff
            rescue RuntimeError => b
              puts(b)
            end
          end
        end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:b,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>42}}}},
         {:define=>
           {:@body=>
             {:block=>
               {:@array=>
                 [{:send=>
                    {:@block=>
                      {:iter=>
                        {:@body=>
                          {:begin=>
                            {:@rescue=>
                              {:rescue=>
                                {:@body=>
                                  {:send=>
                                    {:@block=>nil,
                                     :@name=>:do_stuff,
                                     :@line=>5,
                                     :@privately=>true,
                                     :@receiver=>{:self=>{:@line=>5}},
                                     :@check_for_local=>false}},
                                 :@rescue=>
                                  {:rescuecondition=>
                                    {:@conditions=>
                                      {:arrayliteral=>
                                        {:@body=>
                                          [{:constfind=>
                                             {:@name=>:RuntimeError, :@line=>6}}],
                                         :@line=>6}},
                                     :@body=>
                                      {:block=>
                                        {:@array=>
                                          [{:sendwitharguments=>
                                             {:@block=>nil,
                                              :@name=>:puts,
                                              :@line=>7,
                                              :@privately=>true,
                                              :@receiver=>{:self=>{:@line=>7}},
                                              :@check_for_local=>false,
                                              :@arguments=>
                                               {:actualarguments=>
                                                 {:@array=>
                                                   [{:localvariableaccess=>
                                                      {:@variable=>nil,
                                                       :@name=>:b,
                                                       :@line=>7}}],
                                                  :@splat=>nil,
                                                  :@line=>7}}}}],
                                         :@line=>6}},
                                     :@splat=>nil,
                                     :@next=>nil,
                                     :@line=>6,
                                     :@assignment=>
                                      {:localvariableassignment=>
                                        {:@variable=>nil,
                                         :@name=>:b,
                                         :@line=>6,
                                         :@value=>
                                          {:globalvariableaccess=>
                                            {:@name=>:$!, :@line=>8}}}}}},
                                 :@else=>nil,
                                 :@line=>5}},
                             :@line=>4}},
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
                     :@name=>:c,
                     :@line=>3,
                     :@privately=>true,
                     :@receiver=>{:self=>{:@line=>3}},
                     :@check_for_local=>false}}],
                :@line=>2}},
            :@name=>:a,
            :@line=>2,
            :@arguments=>
             {:formalarguments=>
               {:@block_arg=>nil,
                :@names=>[],
                :@defaults=>nil,
                :@optional=>[],
                :@splat=>nil,
                :@line=>2,
                :@required=>[]}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def x(a=0.0,b=0.0); a+b; end"' do
    ruby = <<-ruby
        def x(a=0.0,b=0.0)
          a+b
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:sendwitharguments=>
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
                     [{:localvariableaccess=>
                        {:@variable=>nil, :@name=>:b, :@line=>2}}],
                    :@splat=>nil,
                    :@line=>2}}}}],
           :@line=>1}},
       :@name=>:x,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:a, :b],
           :@defaults=>
            {:defaultarguments=>
              {:@names=>[:a, :b],
               :@line=>1,
               :@arguments=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:a,
                    :@line=>1,
                    :@value=>{:float=>{:@line=>1, :@value=>:"0.0"}}}},
                 {:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:b,
                    :@line=>1,
                    :@value=>{:float=>{:@line=>1, :@value=>:"0.0"}}}}]}},
           :@optional=>[:a, :b],
           :@splat=>nil,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def x(*b); a(*b); end"' do
    ruby = <<-ruby
        def x(*b)
          a(*b)
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:sendwitharguments=>
               {:@block=>nil,
                :@name=>:a,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false,
                :@arguments=>
                 {:actualarguments=>
                   {:@array=>[],
                    :@splat=>
                     {:splatvalue=>
                       {:@line=>2,
                        :@value=>
                         {:localvariableaccess=>
                           {:@variable=>nil, :@name=>:b, :@line=>2}}}},
                    :@line=>2}}}}],
           :@line=>1}},
       :@name=>:x,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:b],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>:b,
           :@line=>1,
           :@required=>[]}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def meth(b); b; end"' do
    ruby = <<-ruby
        def meth(b)
          b
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:localvariableaccess=>{:@variable=>nil, :@name=>:b, :@line=>2}}],
           :@line=>1}},
       :@name=>:meth,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:b],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>nil,
           :@line=>1,
           :@required=>[:b]}}}}

    ruby.should parse_as(ast)
  end

end
