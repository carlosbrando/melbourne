require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "def x; @@blah = 1; end"' do
    ruby = <<-ruby
        def x
          @@blah = 1
        end
      ruby
    ast  = {:define=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:classvariableassignment=>
               {:@name=>:@@blah,
                :@line=>2,
                :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}}],
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

  it 'should correctly parse "def self.q ... @@q ..."' do
    ruby = <<-ruby
        def self.quiet_mode=(boolean)
          @@quiet_mode = boolean
        end
      ruby
    ast  = {:definesingleton=>
      {:@body=>
        {:definesingletonscope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:classvariableassignment=>
                   {:@name=>:@@quiet_mode,
                    :@line=>2,
                    :@value=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:boolean, :@line=>2}}}}],
               :@line=>1}},
           :@name=>:quiet_mode=,
           :@line=>1,
           :@arguments=>
            {:formalarguments=>
              {:@block_arg=>nil,
               :@names=>[:boolean],
               :@defaults=>nil,
               :@optional=>[],
               :@splat=>nil,
               :@line=>1,
               :@required=>[:boolean]}}}},
       :@line=>1,
       :@receiver=>{:self=>{:@line=>1}}}}

    ruby.should parse_as(ast)
  end

end
