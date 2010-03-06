require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "X = 42"' do
    ruby = 'X = 42'
    ast  = {:constset=>
      {:@parent=>nil,
       :@name=>{:constname=>{:@name=>:X, :@line=>1}},
       :@line=>1,
       :@value=>{:fixnumliteral=>{:@line=>1, :@value=>42}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "::X = 1"' do
    ruby = '::X = 1'
    ast  = {:constset=>
      {:@parent=>{:toplevel=>{:@line=>1}},
       :@name=>{:constname=>{:@name=>:X, :@line=>1}},
       :@line=>1,
       :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "X::Y = 1"' do
    ruby = 'X::Y = 1'
    ast  = {:constset=>
      {:@parent=>{:constfind=>{:@name=>:X, :@line=>1}},
       :@name=>{:constname=>{:@name=>:Y, :@line=>1}},
       :@line=>1,
       :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "X::Y::Z = a"' do
    ruby = 'X::Y::Z = a'
    ast  = {:constset=>
      {:@parent=>
        {:constaccess=>
          {:@parent=>{:constfind=>{:@name=>:X, :@line=>1}},
           :@name=>:Y,
           :@line=>1}},
       :@name=>{:constname=>{:@name=>:Z, :@line=>1}},
       :@line=>1,
       :@value=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a::A = 1"' do
    ruby = 'a::A = 1'
    ast  = {:constset=>
      {:@parent=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@name=>{:constname=>{:@name=>:A, :@line=>1}},
       :@line=>1,
       :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a::B = b"' do
    ruby = <<-ruby
        a = Object
        a::B = b
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:constfind=>{:@name=>:Object, :@line=>1}}}},
         {:constset=>
           {:@parent=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
            :@name=>{:constname=>{:@name=>:B, :@line=>2}},
            :@line=>2,
            :@value=>
             {:send=>
               {:@block=>nil,
                :@name=>:b,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
