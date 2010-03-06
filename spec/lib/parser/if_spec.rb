require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "if true ... else ..."' do
    ruby = <<-ruby
        if true then
          10
        else
          12
        end
      ruby
    ast  = {:if=>
      {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>10}},
       :@condition=>{:true=>{:@line=>1}},
       :@else=>{:fixnumliteral=>{:@line=>4, :@value=>12}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "if b then a end"' do
    ruby = 'if b then a end'
    ast  = {:if=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:b,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@else=>{},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "if (x = 5(x + 1)) then ..."' do
    ruby = <<-ruby
        if (x = 5
        (x + 1)) then
          nil
        end
      ruby
    ast  = {:if=>
      {:@body=>{},
       :@condition=>
        {:block=>
          {:@array=>
            [{:localvariableassignment=>
               {:@variable=>nil,
                :@name=>:x,
                :@line=>1,
                :@value=>{:fixnumliteral=>{:@line=>1, :@value=>5}}}},
             {:sendwitharguments=>
               {:@block=>nil,
                :@name=>:+,
                :@line=>2,
                :@privately=>false,
                :@receiver=>
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:x, :@line=>2}},
                :@check_for_local=>false,
                :@arguments=>
                 {:actualarguments=>
                   {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
                    :@splat=>nil,
                    :@line=>2}}}}],
           :@line=>1}},
       :@else=>{},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "if x = obj.x then ..."' do
    ruby = <<-ruby
        if x = obj.x then
          x.do_it
        end
      ruby
    ast  = {:if=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:do_it,
           :@line=>2,
           :@privately=>false,
           :@receiver=>
            {:localvariableaccess=>{:@variable=>nil, :@name=>:x, :@line=>2}},
           :@check_for_local=>false}},
       :@condition=>
        {:localvariableassignment=>
          {:@variable=>nil,
           :@name=>:x,
           :@line=>1,
           :@value=>
            {:send=>
              {:@block=>nil,
               :@name=>:x,
               :@line=>1,
               :@privately=>false,
               :@receiver=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:obj,
                   :@line=>1,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>1}},
                   :@check_for_local=>false}},
               :@check_for_local=>false}}}},
       :@else=>{},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "return if false unless true"' do
    ruby = 'return if false unless true'
    ast  = {:if=>
      {:@body=>{},
       :@condition=>{:true=>{:@line=>1}},
       :@else=>
        {:if=>
          {:@body=>{:return=>{:@splat=>nil, :@line=>1, :@value=>nil}},
           :@condition=>{:false=>{:@line=>1}},
           :@else=>{},
           :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a if not b"' do
    ruby = 'a if not b'
    ast  = {:if=>
      {:@body=>{},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:b,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@else=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a if b"' do
    ruby = 'a if b'
    ast  = {:if=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:b,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@else=>{},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "if not b then a end"' do
    ruby = 'if not b then a end'
    ast  = {:if=>
      {:@body=>{},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:b,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@else=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "if b then a end"' do
    ruby = 'if b then a end'
    ast  = {:if=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:b,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@else=>{},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a if ()"' do
    ruby = 'a if ()'
    ast  = {:if=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@condition=>{},
       :@else=>{},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "if () then a end"' do
    ruby = 'if () then a end'
    ast  = {:if=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@condition=>{},
       :@else=>{},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a unless not ()"' do
    ruby = 'a unless not ()'
    ast  = {:if=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@condition=>{},
       :@else=>{},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "unless not () then a end"' do
    ruby = 'unless not () then a end'
    ast  = {:if=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@condition=>{},
       :@else=>{},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a unless not b"' do
    ruby = 'a unless not b'
    ast  = {:if=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:b,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@else=>{},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a unless b"' do
    ruby = 'a unless b'
    ast  = {:if=>
      {:@body=>{},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:b,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@else=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "unless not b then a end"' do
    ruby = 'unless not b then a end'
    ast  = {:if=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:b,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@else=>{},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "unless b then a end"' do
    ruby = 'unless b then a end'
    ast  = {:if=>
      {:@body=>{},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:b,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@else=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "unless b then a end"' do
    ruby = 'unless b then a end'
    ast  = {:if=>
      {:@body=>{},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:b,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@else=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
