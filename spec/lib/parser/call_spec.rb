require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "self.method"' do
    ruby = 'self.method'
    ast  = {:send=>
      {:@block=>nil,
       :@name=>:method,
       :@line=>1,
       :@privately=>false,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "1.m(2)"' do
    ruby = '1.m(2)'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:m,
       :@line=>1,
       :@privately=>false,
       :@receiver=>{:fixnumliteral=>{:@line=>1, :@value=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>2}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "h(1, 2, *a)"' do
    ruby = 'h(1, 2, *a)'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:h,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}}],
           :@splat=>
            {:splatvalue=>
              {:@line=>1,
               :@value=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:a,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}}}},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ..."' do
    ruby = <<-ruby
        begin
          (1 + 1)
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:+,
           :@line=>2,
           :@privately=>false,
           :@receiver=>{:fixnumliteral=>{:@line=>2, :@value=>1}},
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
               :@splat=>nil,
               :@line=>2}}}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "blah(*a)"' do
    ruby = 'blah(*a)'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:blah,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>[],
           :@splat=>
            {:splatvalue=>
              {:@line=>1,
               :@value=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:a,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}}}},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a.b(&c)"' do
    ruby = 'a.b(&c)'
    ast  = {:send=>
      {:@block=>
        {:blockpass=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:c,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@line=>1}},
       :@name=>:b,
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
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a.b(4, &c)"' do
    ruby = 'a.b(4, &c)'
    ast  = {:sendwitharguments=>
      {:@block=>
        {:blockpass=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:c,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@line=>1}},
       :@name=>:b,
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
          {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>4}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a.b(1, 2, 3, &c)"' do
    ruby = 'a.b(1, 2, 3, &c)'
    ast  = {:sendwitharguments=>
      {:@block=>
        {:blockpass=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:c,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@line=>1}},
       :@name=>:b,
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
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}},
             {:fixnumliteral=>{:@line=>1, :@value=>3}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a(&b)"' do
    ruby = 'a(&b)'
    ast  = {:send=>
      {:@block=>
        {:blockpass=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@line=>1}},
       :@name=>:a,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a(4, &b)"' do
    ruby = 'a(4, &b)'
    ast  = {:sendwitharguments=>
      {:@block=>
        {:blockpass=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@line=>1}},
       :@name=>:a,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>4}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a(1, 2, 3, &b)"' do
    ruby = 'a(1, 2, 3, &b)'
    ast  = {:sendwitharguments=>
      {:@block=>
        {:blockpass=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@line=>1}},
       :@name=>:a,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}},
             {:fixnumliteral=>{:@line=>1, :@value=>3}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "define_attr_method(:x, :sequence_name, &Proc.new { |*args| nil })"' do
    ruby = 'define_attr_method(:x, :sequence_name, &Proc.new { |*args| nil })'
    ast  = {:sendwitharguments=>
      {:@block=>
        {:blockpass=>
          {:@body=>
            {:send=>
              {:@block=>
                {:iter=>
                  {:@body=>{},
                   :@line=>1,
                   :@arguments=>
                    {:iterarguments=>
                      {:@block=>nil,
                       :@arity=>-1,
                       :@prelude=>:splat,
                       :@optional=>1,
                       :@splat=>
                        {:localvariableassignment=>
                          {:@variable=>nil,
                           :@name=>:args,
                           :@line=>1,
                           :@value=>nil}},
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
                              {:@variable=>nil,
                               :@name=>:args,
                               :@line=>1,
                               :@value=>nil}},
                           :@line=>1,
                           :@left=>nil,
                           :@right=>nil}}}}}},
               :@name=>:new,
               :@line=>1,
               :@privately=>false,
               :@receiver=>{:constfind=>{:@name=>:Proc, :@line=>1}},
               :@check_for_local=>false}},
           :@line=>1}},
       :@name=>:define_attr_method,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:symbolliteral=>{:@line=>1, :@value=>:x}},
             {:symbolliteral=>{:@line=>1, :@value=>:sequence_name}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "r.read_body(dest, &block)"' do
    ruby = 'r.read_body(dest, &block)'
    ast  = {:sendwitharguments=>
      {:@block=>
        {:blockpass=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:block,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@line=>1}},
       :@name=>:read_body,
       :@line=>1,
       :@privately=>false,
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:r,
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
                :@name=>:dest,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "o.m(:a => 1, :b => 2)"' do
    ruby = 'o.m(:a => 1, :b => 2)'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:m,
       :@line=>1,
       :@privately=>false,
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:o,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:hashliteral=>
               {:@array=>
                 [{:symbolliteral=>{:@line=>1, :@value=>:a}},
                  {:fixnumliteral=>{:@line=>1, :@value=>1}},
                  {:symbolliteral=>{:@line=>1, :@value=>:b}},
                  {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                :@line=>1}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "o.m(42, :a => 1, :b => 2)"' do
    ruby = 'o.m(42, :a => 1, :b => 2)'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:m,
       :@line=>1,
       :@privately=>false,
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:o,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:fixnumliteral=>{:@line=>1, :@value=>42}},
             {:hashliteral=>
               {:@array=>
                 [{:symbolliteral=>{:@line=>1, :@value=>:a}},
                  {:fixnumliteral=>{:@line=>1, :@value=>1}},
                  {:symbolliteral=>{:@line=>1, :@value=>:b}},
                  {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                :@line=>1}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "o.m(42, :a => 1, :b => 2, *c)"' do
    ruby = 'o.m(42, :a => 1, :b => 2, *c)'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:m,
       :@line=>1,
       :@privately=>false,
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:o,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:fixnumliteral=>{:@line=>1, :@value=>42}},
             {:hashliteral=>
               {:@array=>
                 [{:symbolliteral=>{:@line=>1, :@value=>:a}},
                  {:fixnumliteral=>{:@line=>1, :@value=>1}},
                  {:symbolliteral=>{:@line=>1, :@value=>:b}},
                  {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                :@line=>1}}],
           :@splat=>
            {:splatvalue=>
              {:@line=>1,
               :@value=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:c,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}}}},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a (1,2,3)"' do
    ruby = 'a (1,2,3)'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:a,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}},
             {:fixnumliteral=>{:@line=>1, :@value=>3}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "o.puts(42)"' do
    ruby = 'o.puts(42)'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:puts,
       :@line=>1,
       :@privately=>false,
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:o,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>42}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "1.b(c)"' do
    ruby = '1.b(c)'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:b,
       :@line=>1,
       :@privately=>false,
       :@receiver=>{:fixnumliteral=>{:@line=>1, :@value=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:send=>
               {:@block=>nil,
                :@name=>:c,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "(v = (1 + 1)).zero?"' do
    ruby = '(v = (1 + 1)).zero?'
    ast  = {:send=>
      {:@block=>nil,
       :@name=>:zero?,
       :@line=>1,
       :@privately=>false,
       :@receiver=>
        {:localvariableassignment=>
          {:@variable=>nil,
           :@name=>:v,
           :@line=>1,
           :@value=>
            {:sendwitharguments=>
              {:@block=>nil,
               :@name=>:+,
               :@line=>1,
               :@privately=>false,
               :@receiver=>{:fixnumliteral=>{:@line=>1, :@value=>1}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                   :@splat=>nil,
                   :@line=>1}}}}}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "-2**31"' do
    ruby = '-2**31'
    ast  = {:send=>
      {:@block=>nil,
       :@name=>:-@,
       :@line=>1,
       :@privately=>false,
       :@receiver=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:**,
           :@line=>1,
           :@privately=>false,
           :@receiver=>{:fixnumliteral=>{:@line=>1, :@value=>2}},
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>31}}],
               :@splat=>nil,
               :@line=>1}}}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a[]"' do
    ruby = 'a[]'
    ast  = {:send=>
      {:@block=>nil,
       :@name=>:[],
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
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m(:a => 1, :b => 2)"' do
    ruby = 'm(:a => 1, :b => 2)'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:hashliteral=>
               {:@array=>
                 [{:symbolliteral=>{:@line=>1, :@value=>:a}},
                  {:fixnumliteral=>{:@line=>1, :@value=>1}},
                  {:symbolliteral=>{:@line=>1, :@value=>:b}},
                  {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                :@line=>1}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m(42, :a => 1, :b => 2)"' do
    ruby = 'm(42, :a => 1, :b => 2)'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:fixnumliteral=>{:@line=>1, :@value=>42}},
             {:hashliteral=>
               {:@array=>
                 [{:symbolliteral=>{:@line=>1, :@value=>:a}},
                  {:fixnumliteral=>{:@line=>1, :@value=>1}},
                  {:symbolliteral=>{:@line=>1, :@value=>:b}},
                  {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                :@line=>1}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m(42, :a => 1, :b => 2, *c)"' do
    ruby = 'm(42, :a => 1, :b => 2, *c)'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:fixnumliteral=>{:@line=>1, :@value=>42}},
             {:hashliteral=>
               {:@array=>
                 [{:symbolliteral=>{:@line=>1, :@value=>:a}},
                  {:fixnumliteral=>{:@line=>1, :@value=>1}},
                  {:symbolliteral=>{:@line=>1, :@value=>:b}},
                  {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                :@line=>1}}],
           :@splat=>
            {:splatvalue=>
              {:@line=>1,
               :@value=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:c,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}}}},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "m(42)"' do
    ruby = 'm(42)'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:m,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>42}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a(:b) { :c }"' do
    ruby = 'a(:b) { :c }'
    ast  = {:sendwitharguments=>
      {:@block=>
        {:iter=>
          {:@body=>{:symbolliteral=>{:@line=>1, :@value=>:c}},
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
       :@name=>:a,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>[{:symbolliteral=>{:@line=>1, :@value=>:b}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a [42]"' do
    ruby = 'a [42]'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:a,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:arrayliteral=>
               {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>42}}], :@line=>1}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "42 if block_given?"' do
    ruby = '42 if block_given?'
    ast  = {:if=>
      {:@body=>{:fixnumliteral=>{:@line=>1, :@value=>42}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:block_given?,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@else=>{},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "method"' do
    ruby = 'method'
    ast  = {:send=>
      {:@block=>nil,
       :@name=>:method,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue ..."' do
    ruby = <<-ruby
        a << begin
               b
             rescue
               c
             end
      ruby
    ast  =   {:sendwitharguments=>
        {:@block=>nil,
         :@name=>:<<,
         :@line=>5,
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
              [{:rescue=>
                 {:@body=>
                   {:send=>
                     {:@block=>nil,
                      :@name=>:b,
                      :@line=>2,
                      :@privately=>true,
                      :@receiver=>{:self=>{:@line=>2}},
                      :@check_for_local=>false}},
                  :@rescue=>
                   {:rescuecondition=>
                     {:@conditions=>
                       {:arrayliteral=>
                         {:@body=>
                           [{:constfind=>{:@name=>:StandardError, :@line=>4}}],
                          :@line=>4}},
                      :@body=>
                       {:send=>
                         {:@block=>nil,
                          :@name=>:c,
                          :@line=>4,
                          :@privately=>true,
                          :@receiver=>{:self=>{:@line=>4}},
                          :@check_for_local=>false}},
                      :@splat=>nil,
                      :@next=>nil,
                      :@line=>4,
                      :@assignment=>nil}},
                  :@else=>nil,
                  :@line=>2}}],
             :@splat=>nil,
             :@line=>5}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "meth([*[1]])"' do
    ruby = 'meth([*[1]])'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:meth,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:splatvalue=>
               {:@line=>1,
                :@value=>
                 {:arrayliteral=>
                   {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                    :@line=>1}}}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "meth(*[1])"' do
    ruby = 'meth(*[1])'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:meth,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>[],
           :@splat=>
            {:splatvalue=>
              {:@line=>1,
               :@value=>
                {:arrayliteral=>
                  {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                   :@line=>1}}}},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

end
