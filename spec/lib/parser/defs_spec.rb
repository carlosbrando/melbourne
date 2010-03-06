require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "def self.x(y); (y + 1); end"' do
    ruby = <<-ruby
        def self.x(y)
          (y + 1)
        end
      ruby
    ast  = {:definesingleton=>
      {:@body=>
        {:definesingletonscope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:sendwitharguments=>
                   {:@block=>nil,
                    :@name=>:+,
                    :@line=>2,
                    :@privately=>false,
                    :@receiver=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:y, :@line=>2}},
                    :@check_for_local=>false,
                    :@arguments=>
                     {:actualarguments=>
                       {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
                        :@splat=>nil,
                        :@line=>2}}}}],
               :@line=>1}},
           :@name=>:x,
           :@line=>1,
           :@arguments=>
            {:formalarguments=>
              {:@block_arg=>nil,
               :@names=>[:y],
               :@defaults=>nil,
               :@optional=>[],
               :@splat=>nil,
               :@line=>1,
               :@required=>[:y]}}}},
       :@line=>1,
       :@receiver=>{:self=>{:@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "self.setup(ctx) ..."' do
    ruby = <<-ruby
        def self.setup(ctx)
          bind = allocate
          bind.context = ctx
          return bind
        end
      ruby
    ast  = {:definesingleton=>
      {:@body=>
        {:definesingletonscope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:localvariableassignment=>
                   {:@variable=>nil,
                    :@name=>:bind,
                    :@line=>2,
                    :@value=>
                     {:send=>
                       {:@block=>nil,
                        :@name=>:allocate,
                        :@line=>2,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>2}},
                        :@check_for_local=>false}}}},
                 {:attributeassignment=>
                   {:@name=>:context=,
                    :@line=>3,
                    :@privately=>false,
                    :@receiver=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:bind, :@line=>3}},
                    :@arguments=>
                     {:actualarguments=>
                       {:@array=>
                         [{:localvariableaccess=>
                            {:@variable=>nil, :@name=>:ctx, :@line=>3}}],
                        :@splat=>nil,
                        :@line=>3}}}},
                 {:return=>
                   {:@splat=>nil,
                    :@line=>4,
                    :@value=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:bind, :@line=>4}}}}],
               :@line=>1}},
           :@name=>:setup,
           :@line=>1,
           :@arguments=>
            {:formalarguments=>
              {:@block_arg=>nil,
               :@names=>[:ctx],
               :@defaults=>nil,
               :@optional=>[],
               :@splat=>nil,
               :@line=>1,
               :@required=>[:ctx]}}}},
       :@line=>1,
       :@receiver=>{:self=>{:@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def self.empty(*); end"' do
    ruby = <<-ruby
        def self.empty(*)
        end
      ruby
    ast  = {:definesingleton=>
      {:@body=>
        {:definesingletonscope=>
          {:@body=>{:block=>{:@array=>[{}], :@line=>2}},
           :@name=>:empty,
           :@line=>1,
           :@arguments=>
            {:formalarguments=>
              {:@block_arg=>nil,
               :@names=>[:@unnamed_splat],
               :@defaults=>nil,
               :@optional=>[],
               :@splat=>:@unnamed_splat,
               :@line=>1,
               :@required=>[]}}}},
       :@line=>1,
       :@receiver=>{:self=>{:@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def self.empty; end"' do
    ruby = <<-ruby
        def self.empty
        end
      ruby
    ast  = {:definesingleton=>
      {:@body=>
        {:definesingletonscope=>
          {:@body=>{:block=>{:@array=>[{}], :@line=>2}},
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
               :@required=>[]}}}},
       :@line=>1,
       :@receiver=>{:self=>{:@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def (a,b).empty(*); end"' do
    ruby = <<-ruby
        def (a.b).empty(*)
        end
      ruby
    ast  = {:definesingleton=>
      {:@body=>
        {:definesingletonscope=>
          {:@body=>{:block=>{:@array=>[{}], :@line=>2}},
           :@name=>:empty,
           :@line=>1,
           :@arguments=>
            {:formalarguments=>
              {:@block_arg=>nil,
               :@names=>[:@unnamed_splat],
               :@defaults=>nil,
               :@optional=>[],
               :@splat=>:@unnamed_splat,
               :@line=>1,
               :@required=>[]}}}},
       :@line=>1,
       :@receiver=>
        {:send=>
          {:@block=>nil,
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
           :@check_for_local=>false}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "def x.m(a) ..."' do
    ruby = <<-ruby
      x = "a"
      def x.m(a)
        a
      end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:x,
            :@line=>1,
            :@value=>{:stringliteral=>{:@string=>:a, :@line=>1}}}},
         {:definesingleton=>
           {:@body=>
             {:definesingletonscope=>
               {:@body=>
                 {:block=>
                   {:@array=>
                     [{:localvariableaccess=>
                        {:@variable=>nil, :@name=>:a, :@line=>3}}],
                    :@line=>2}},
                :@name=>:m,
                :@line=>2,
                :@arguments=>
                 {:formalarguments=>
                   {:@block_arg=>nil,
                    :@names=>[:a],
                    :@defaults=>nil,
                    :@optional=>[],
                    :@splat=>nil,
                    :@line=>2,
                    :@required=>[:a]}}}},
            :@line=>2,
            :@receiver=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:x, :@line=>2}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
