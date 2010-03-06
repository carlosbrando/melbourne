require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "(a..b)"' do
    ruby = '(a..b)'
    ast  = {:range=>
      {:@start=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@finish=>
        {:send=>
          {:@block=>nil,
           :@name=>:b,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
