require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "while not a ..."' do
    ruby = <<-ruby
        while not a
          b + 1
        end
      ruby
    ast  = {:until=>
      {:@body=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:+,
           :@line=>2,
           :@privately=>false,
           :@receiver=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>2,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>2}},
               :@check_for_local=>false}},
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
               :@splat=>nil,
               :@line=>2}}}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "b + 1 while not a"' do
    ruby = 'b + 1 while not a'
    ast  = {:until=>
      {:@body=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:+,
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
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
               :@splat=>nil,
               :@line=>1}}}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "until a ..."' do
    ruby = <<-ruby
        until a
          b + 1
        end
      ruby
    ast  = {:until=>
      {:@body=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:+,
           :@line=>2,
           :@privately=>false,
           :@receiver=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>2,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>2}},
               :@check_for_local=>false}},
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
               :@splat=>nil,
               :@line=>2}}}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... end while ..."' do
    ruby = <<-ruby
        begin
          b + 1
        end while not a
      ruby
    ast  = {:until=>
      {:@body=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:+,
           :@line=>2,
           :@privately=>false,
           :@receiver=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>2,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>2}},
               :@check_for_local=>false}},
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
               :@splat=>nil,
               :@line=>2}}}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>3,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>3}},
           :@check_for_local=>false}},
       :@line=>3,
       :@check_first=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... end until ..."' do
    ruby = <<-ruby
        begin
          b + 1
        end until a
      ruby
    ast  = {:until=>
      {:@body=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:+,
           :@line=>2,
           :@privately=>false,
           :@receiver=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>2,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>2}},
               :@check_for_local=>false}},
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
               :@splat=>nil,
               :@line=>2}}}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>3,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>3}},
           :@check_for_local=>false}},
       :@line=>3,
       :@check_first=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "until () ..."' do
    ruby = <<-ruby
        until ()
          a
        end
      ruby
    ast  = {:until=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>2,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>2}},
           :@check_for_local=>false}},
       :@condition=>{},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a until ()"' do
    ruby = 'a until ()'
    ast  = {:until=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@condition=>{},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a while not ()"' do
    ruby = 'a while not ()'
    ast  = {:until=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@condition=>{},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "while not () ..."' do
    ruby = <<-ruby
        while not ()
          a
        end
      ruby
    ast  = {:until=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>2,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>2}},
           :@check_for_local=>false}},
       :@condition=>{},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

end
