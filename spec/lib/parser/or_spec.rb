require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "(a or b)"' do
    ruby = '(a or b)'
    ast  = {:or=>
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

  it 'should correctly parse "((a || b) || (c && d))"' do
    ruby = '((a || b) || (c && d))'
    ast  = {:or=>
      {:@line=>1,
       :@left=>
        {:or=>
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
               :@check_for_local=>false}}}},
       :@right=>
        {:and=>
          {:@line=>1,
           :@left=>
            {:send=>
              {:@block=>nil,
               :@name=>:c,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@right=>
            {:send=>
              {:@block=>nil,
               :@name=>:d,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "((a or b) or (c and d))"' do
    ruby = '((a or b) or (c and d))'
    ast  = {:or=>
      {:@line=>1,
       :@left=>
        {:or=>
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
               :@check_for_local=>false}}}},
       :@right=>
        {:and=>
          {:@line=>1,
           :@left=>
            {:send=>
              {:@block=>nil,
               :@name=>:c,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@right=>
            {:send=>
              {:@block=>nil,
               :@name=>:d,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "() or a"' do
    ruby = '() or a'
    ast  = {:or=>
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

  it 'should correctly parse "a or ()"' do
    ruby = 'a or ()'
    ast  = {:or=>
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
