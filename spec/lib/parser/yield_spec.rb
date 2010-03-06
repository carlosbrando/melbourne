require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "yield(42, 24)"' do
    ruby = 'yield(42, 24)'
    ast  = {:yield=>
      {:@argument_count=>2,
       :@yield_splat=>false,
       :@line=>1,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:fixnumliteral=>{:@line=>1, :@value=>42}},
             {:fixnumliteral=>{:@line=>1, :@value=>24}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "yield([42, 24])"' do
    ruby = 'yield([42, 24])'
    ast  = {:yield=>
      {:@argument_count=>1,
       :@yield_splat=>false,
       :@line=>1,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:arrayliteral=>
               {:@body=>
                 [{:fixnumliteral=>{:@line=>1, :@value=>42}},
                  {:fixnumliteral=>{:@line=>1, :@value=>24}}],
                :@line=>1}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "yield([42])"' do
    ruby = 'yield([42])'
    ast  = {:yield=>
      {:@argument_count=>1,
       :@yield_splat=>false,
       :@line=>1,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:arrayliteral=>
               {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>42}}], :@line=>1}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "yield([])"' do
    ruby = 'yield([])'
    ast  = {:yield=>
      {:@argument_count=>1,
       :@yield_splat=>false,
       :@line=>1,
       :@arguments=>
        {:actualarguments=>
          {:@array=>[{:emptyarray=>{:@line=>1}}], :@splat=>nil, :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "yield(42)"' do
    ruby = 'yield(42)'
    ast  = {:yield=>
      {:@argument_count=>1,
       :@yield_splat=>false,
       :@line=>1,
       :@arguments=>
        {:actualarguments=>
          {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>42}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "yield"' do
    ruby = 'yield'
    ast  = {:yield=>
      {:@argument_count=>0,
       :@yield_splat=>false,
       :@line=>1,
       :@arguments=>{:actualarguments=>{:@array=>[], :@splat=>nil, :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "yield([*[]])"' do
    ruby = 'yield([*[]])'
    ast  = {:yield=>
      {:@argument_count=>1,
       :@yield_splat=>false,
       :@line=>1,
       :@arguments=>
        {:actualarguments=>
          {:@array=>[],
           :@splat=>
            {:splatvalue=>{:@line=>1, :@value=>{:emptyarray=>{:@line=>1}}}},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "yield([*[1]])"' do
    ruby = 'yield([*[1]])'
    ast  = {:yield=>
      {:@argument_count=>1,
       :@yield_splat=>false,
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

  it 'should correctly parse "yield([*[1, 2]])"' do
    ruby = 'yield([*[1, 2]])'
    ast  = {:yield=>
      {:@argument_count=>1,
       :@yield_splat=>false,
       :@line=>1,
       :@arguments=>
        {:actualarguments=>
          {:@array=>[],
           :@splat=>
            {:splatvalue=>
              {:@line=>1,
               :@value=>
                {:arrayliteral=>
                  {:@body=>
                    [{:fixnumliteral=>{:@line=>1, :@value=>1}},
                     {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                   :@line=>1}}}},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "yield(*[1])"' do
    ruby = 'yield(*[1])'
    ast  = {:yield=>
      {:@argument_count=>0,
       :@yield_splat=>true,
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

  it 'should correctly parse "yield(*[1, 2])"' do
    ruby = 'yield(*[1, 2])'
    ast  = {:yield=>
      {:@argument_count=>0,
       :@yield_splat=>true,
       :@line=>1,
       :@arguments=>
        {:actualarguments=>
          {:@array=>[],
           :@splat=>
            {:splatvalue=>
              {:@line=>1,
               :@value=>
                {:arrayliteral=>
                  {:@body=>
                    [{:fixnumliteral=>{:@line=>1, :@value=>1}},
                     {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                   :@line=>1}}}},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

end
