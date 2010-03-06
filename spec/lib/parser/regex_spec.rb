require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "str.split(//i)"' do
    ruby = 'str.split(//i)'
    ast  = {:sendwitharguments=>
      {:@block=>nil,
       :@name=>:split,
       :@line=>1,
       :@privately=>false,
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:str,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@check_for_local=>false,
       :@arguments=>
        {:actualarguments=>
          {:@array=>
            [{:regexliteral=>{:@source=>:"<blank>", :@options=>1, :@line=>1}}],
           :@splat=>nil,
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "/x/n"' do
    ruby = '/x/n'
    ast  = {:regexliteral=>{:@source=>:x, :@options=>16, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "/x/o"' do
    ruby = '/x/o'
    ast  = {:regexliteral=>{:@source=>:x, :@options=>0, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "/x/"' do
    ruby = '/x/'
    ast  = {:regexliteral=>{:@source=>:x, :@options=>0, :@line=>1}}

    ruby.should parse_as(ast)
  end

end
