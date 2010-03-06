require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "{ 1 => 2, 3 => 4 }"' do
    ruby = '{ 1 => 2, 3 => 4 }'
    ast  = {:hashliteral=>
      {:@array=>
        [{:fixnumliteral=>{:@line=>1, :@value=>1}},
         {:fixnumliteral=>{:@line=>1, :@value=>2}},
         {:fixnumliteral=>{:@line=>1, :@value=>3}},
         {:fixnumliteral=>{:@line=>1, :@value=>4}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "{ 1 => (2 rescue 3) }"' do
    ruby = '{ 1 => (2 rescue 3) }'
    ast  = {:hashliteral=>
      {:@array=>
        [{:fixnumliteral=>{:@line=>1, :@value=>1}},
         {:rescue=>
           {:@body=>{:fixnumliteral=>{:@line=>1, :@value=>2}},
            :@rescue=>
             {:rescuecondition=>
               {:@conditions=>
                 {:arrayliteral=>
                   {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>1}}],
                    :@line=>1}},
                :@body=>{:fixnumliteral=>{:@line=>1, :@value=>3}},
                :@splat=>nil,
                :@next=>nil,
                :@line=>1,
                :@assignment=>nil}},
            :@else=>nil,
            :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "{ 1 => [*1] }"' do
    ruby = '{ 1 => [*1] }'
    ast  = {:hashliteral=>
      {:@array=>
        [{:fixnumliteral=>{:@line=>1, :@value=>1}},
         {:splatvalue=>
           {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = 1; { :a => a }"' do
    ruby = <<-ruby
        a = 1
        { :a => a }
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:hashliteral=>
           {:@array=>
             [{:symbolliteral=>{:@line=>2, :@value=>:a}},
              {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}}],
            :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
