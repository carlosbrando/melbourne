require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "/(#{})/"' do
    ruby = '/(#{})/'
    ast  = {:dynamicregex=>
      {:@string=>:"(",
       :@array=>
        [{:stringliteral=>{:@string=>:"<blank>", :@line=>1}},
         {:stringliteral=>{:@string=>:")", :@line=>1}}],
       :@options=>0,
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "/x\#{(1 + 1)}y/"' do
    ruby = '/x#{(1 + 1)}y/'
    ast  = {:dynamicregex=>
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
       :@options=>0,
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "/a\#{}b/"' do
    ruby = '/a#{}b/'
    ast  = {:dynamicregex=>
      {:@string=>:a,
       :@array=>
        [{:stringliteral=>{:@string=>:"<blank>", :@line=>1}},
         {:stringliteral=>{:@string=>:b, :@line=>1}}],
       :@options=>0,
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "/\#{@rakefile}/"' do
    ruby = '/#{@rakefile}/'
    ast  = {:dynamicregex=>
      {:@string=>:"<blank>",
       :@array=>
        [{:tostring=>
           {:@line=>1,
            :@value=>{:instancevariableaccess=>{:@name=>:@rakefile, :@line=>1}}}}],
       :@options=>0,
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "/\#{1}/n"' do
    ruby = '/#{1}/n'
    ast  = {:dynamicregex=>
      {:@string=>:"<blank>",
       :@array=>
        [{:tostring=>
           {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}],
       :@options=>16,
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "/\#{IAC}\#{SB}/no"' do
    ruby = '/#{IAC}#{SB}/no'
    ast  = {:dynamiconceregex=>
      {:@string=>:"<blank>",
       :@array=>
        [{:tostring=>
           {:@line=>1, :@value=>{:constfind=>{:@name=>:IAC, :@line=>1}}}},
         {:tostring=>
           {:@line=>1, :@value=>{:constfind=>{:@name=>:SB, :@line=>1}}}}],
       :@options=>16,
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "/x\#{(1 + 1)}y/o"' do
    ruby = '/x#{(1 + 1)}y/o'
    ast  = {:dynamiconceregex=>
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
       :@options=>0,
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
