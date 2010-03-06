require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "def x; super(); end"' do
    ruby = <<-ruby
        def x
          super()
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:super=>
               {:@block=>nil,
                :@line=>2,
                :@arguments=>
                 {:actualarguments=>{:@array=>[], :@splat=>nil, :@line=>2}}}}],
           :@line=>1}},
       :@name=>:x,
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

  it 'should correctly parse "def x(&block); super(&block); end"' do
    ruby = <<-ruby
        def x(&block)
          super(&block)
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:super=>
               {:@block=>
                 {:blockpass=>
                   {:@body=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:block, :@line=>2}},
                    :@line=>2}},
                :@line=>2,
                :@arguments=>
                 {:actualarguments=>{:@array=>[], :@splat=>nil, :@line=>2}}}}],
           :@line=>1}},
       :@name=>:x,
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

  it 'should correctly parse "def x; super([24, 42]); end"' do
    ruby = <<-ruby
        def x
          super([24, 42])
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:super=>
               {:@block=>nil,
                :@line=>2,
                :@arguments=>
                 {:actualarguments=>
                   {:@array=>
                     [{:arrayliteral=>
                        {:@body=>
                          [{:fixnumliteral=>{:@line=>2, :@value=>24}},
                           {:fixnumliteral=>{:@line=>2, :@value=>42}}],
                         :@line=>2}}],
                    :@splat=>nil,
                    :@line=>2}}}}],
           :@line=>1}},
       :@name=>:x,
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

  it 'should correctly parse "def x; super(4); end"' do
    ruby = <<-ruby
        def x
          super(4)
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:super=>
               {:@block=>nil,
                :@line=>2,
                :@arguments=>
                 {:actualarguments=>
                   {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>4}}],
                    :@splat=>nil,
                    :@line=>2}}}}],
           :@line=>1}},
       :@name=>:x,
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

  it 'should correctly parse "super(a, &b)"' do
    ruby = 'super(a, &b)'
    ast  = {:super=>
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
       :@line=>1,
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

  it 'should correctly parse "def f(*); super; end"' do
    ruby = <<-ruby
        def f(*)
          super
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>{:@array=>[{:zsuper=>{:@block=>nil, :@line=>2}}], :@line=>1}},
       :@name=>:f,
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

  it 'should correctly parse "def x; super(24, 42); end"' do
    ruby = <<-ruby
        def x
          super(24, 42)
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:super=>
               {:@block=>nil,
                :@line=>2,
                :@arguments=>
                 {:actualarguments=>
                   {:@array=>
                     [{:fixnumliteral=>{:@line=>2, :@value=>24}},
                      {:fixnumliteral=>{:@line=>2, :@value=>42}}],
                    :@splat=>nil,
                    :@line=>2}}}}],
           :@line=>1}},
       :@name=>:x,
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

  it 'should correctly parse "super([*[1]])"' do
    ruby = 'super([*[1]])'
    ast  = {:super=>
      {:@block=>nil,
       :@line=>1,
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

  it 'should correctly parse "super(*[1])"' do
    ruby = 'super(*[1])'
    ast  = {:super=>
      {:@block=>nil,
       :@line=>1,
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
