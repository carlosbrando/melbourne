require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse ":"x#{(1 + 1)}y""' do
    ruby = ':"x#{(1 + 1)}y"'
    ast  = {:dynamicsymbol=>
      {:@string=>:x,
       :@array=>
        [{:tostring=>
           {:@line=>1,
            :@value=>
             {:sendwitharguments=>
               {:@block=>nil,
                :@name=>:+,
                :@line=>1,
                :@privately=>false,
                :@receiver=>{:fixnumliteral=>{:@line=>1, :@value=>1}},
                :@check_for_local=>false,
                :@arguments=>
                 {:actualarguments=>
                   {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                    :@splat=>nil,
                    :@line=>1}}}}}},
         {:stringliteral=>{:@string=>:y, :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
