require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "$x"' do
    ruby = '$x'
    ast  = {:globalvariableaccess=>{:@name=>:$x, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "$stderr"' do
    ruby = '$stderr'
    ast  = {:globalvariableaccess=>{:@name=>:$stderr, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "$__blah"' do
    ruby = '$__blah'
    ast  = {:globalvariableaccess=>{:@name=>:$__blah, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "$_"' do
    ruby = '$_'
    ast  = {:globalvariableaccess=>{:@name=>:$_, :@line=>1}}

    ruby.should parse_as(ast)
  end

end
