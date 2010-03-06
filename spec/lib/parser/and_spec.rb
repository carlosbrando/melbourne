require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "(a and b)"' do
    ruby = '(a and b)'
    ast  = {:and=>
      {:@line=>1,
       :@left=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@right=>
        {:send=>
          {:@block=>nil,
           :@name=>:b,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "() and a"' do
    ruby = '() and a'
    ast  = {:and=>
      {:@line=>1,
       :@left=>{},
       :@right=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a and ()"' do
    ruby = 'a and ()'
    ast  = {:and=>
      {:@line=>1,
       :@left=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@right=>{}}}

    ruby.should parse_as(ast)
  end

end
