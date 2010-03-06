require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "def x; super; end"' do
    ruby = <<-ruby
        def x
          super
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>{:@array=>[{:zsuper=>{:@block=>nil, :@line=>2}}], :@line=>1}},
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

  it 'should correctly parse "def x(a); super; end"' do
    ruby = <<-ruby
        def x(a)
          super
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>{:@array=>[{:zsuper=>{:@block=>nil, :@line=>2}}], :@line=>1}},
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

  it 'should correctly parse "def x(&block); super; end"' do
    ruby = <<-ruby
        def x(&block)
          super
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>{:@array=>[{:zsuper=>{:@block=>nil, :@line=>2}}], :@line=>1}},
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

  it 'should correctly parse "def x(a, *as); super; end"' do
    ruby = <<-ruby
        def x(a, *as)
          super
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>{:@array=>[{:zsuper=>{:@block=>nil, :@line=>2}}], :@line=>1}},
       :@name=>:x,
       :@line=>1,
       :@arguments=>
        {:formalarguments=>
          {:@block_arg=>nil,
           :@names=>[:a, :as],
           :@defaults=>nil,
           :@optional=>[],
           :@splat=>:as,
           :@line=>1,
           :@required=>[:a]}}}}

    ruby.should parse_as(ast)
  end

end
