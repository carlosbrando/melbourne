require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "END { 1 }"' do
    ruby = 'END { 1 }'
    ast  = {:send=>
      {:@block=>
        {:iter=>
          {:@body=>{:fixnumliteral=>{:@line=>1, :@value=>1}},
           :@line=>1,
           :@arguments=>
            {:iterarguments=>
              {:@block=>nil,
               :@arity=>-1,
               :@prelude=>nil,
               :@optional=>0,
               :@splat=>nil,
               :@line=>1,
               :@splat_index=>-2,
               :@required_args=>0}}}},
       :@name=>:at_exit,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

end
