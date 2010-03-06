require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "0b1111"' do
    ruby = '0b1111'
    ast  = {:fixnumliteral=>{:@line=>1, :@value=>15}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "1.1"' do
    ruby = '1.1'
    ast  = {:float=>{:@line=>1, :@value=>:"1.1"}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "0xffffffffffffffff"' do
    ruby = '0xffffffffffffffff'
    ast  = {:numberliteral=>{:@line=>1, :@value=>:"18446744073709551615"}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "0xffff_ffff_ffff_ffff"' do
    ruby = '0xffff_ffff_ffff_ffff'
    ast  = {:numberliteral=>{:@line=>1, :@value=>:"18446744073709551615"}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "07654"' do
    ruby = '07654'
    ast  = {:fixnumliteral=>{:@line=>1, :@value=>4012}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "-1"' do
    ruby = '-1'
    ast  = {:negate=>{:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "1"' do
    ruby = '1'
    ast  = {:fixnumliteral=>{:@line=>1, :@value=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "8000_0000"' do
    ruby = '8000_0000'
    ast  = {:fixnumliteral=>{:@line=>1, :@value=>80000000}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse ":x"' do
    ruby = ':x'
    ast  = {:symbolliteral=>{:@line=>1, :@value=>:x}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse ":"*args""' do
    ruby = ':"*args"'
    ast  = {:symbolliteral=>{:@line=>1, :@value=>:"*args"}}

    ruby.should parse_as(ast)
  end

end
