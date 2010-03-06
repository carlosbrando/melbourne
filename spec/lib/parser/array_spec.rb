require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "[1, :b, "c"]"' do
    ruby = '[1, :b, "c"]'
    ast  = {:arrayliteral=>
      {:@body=>
        [{:fixnumliteral=>{:@line=>1, :@value=>1}},
         {:symbolliteral=>{:@line=>1, :@value=>:b}},
         {:stringliteral=>{:@string=>:c, :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "%w[a b c]"' do
    ruby = '%w[a b c]'
    ast  = {:arrayliteral=>
      {:@body=>
        [{:stringliteral=>{:@string=>:a, :@line=>1}},
         {:stringliteral=>{:@string=>:b, :@line=>1}},
         {:stringliteral=>{:@string=>:c, :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "%w[a #{@b} c]"' do
    ruby = '%w[a #{@b} c]'
    ast  = {:arrayliteral=>
      {:@body=>
        [{:stringliteral=>{:@string=>:a, :@line=>1}},
         {:stringliteral=>{:@string=>:"\#{@b}", :@line=>1}},
         {:stringliteral=>{:@string=>:c, :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "%W[a b c]"' do
    ruby = '%W[a b c]'
    ast  = {:arrayliteral=>
      {:@body=>
        [{:stringliteral=>{:@string=>:a, :@line=>1}},
         {:stringliteral=>{:@string=>:b, :@line=>1}},
         {:stringliteral=>{:@string=>:c, :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "%W[a #{@b} c]"' do
    ruby = '%W[a #{@b} c]'
    ast  = {:arrayliteral=>
      {:@body=>
        [{:stringliteral=>{:@string=>:a, :@line=>1}},
         {:dynamicstring=>
           {:@string=>:"<blank>",
            :@array=>
             [{:tostring=>
                {:@line=>1,
                 :@value=>{:instancevariableaccess=>{:@name=>:@b, :@line=>1}}}}],
            :@line=>1}},
         {:stringliteral=>{:@string=>:c, :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "[*[1]]"' do
    ruby = '[*[1]]'
    ast  = {:splatvalue=>
      {:@line=>1,
       :@value=>
        {:arrayliteral=>
          {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}], :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "[*1]"' do
    ruby = '[*1]'
    ast  = {:splatvalue=>{:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "[[*1]]"' do
    ruby = '[[*1]]'
    ast  = {:arrayliteral=>
      {:@body=>
        [{:splatvalue=>
           {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "[1, *2]"' do
    ruby = '[1, *2]'
    ast  = {:concatargs=>
      {:@array=>
        {:arrayliteral=>
          {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}], :@line=>1}},
       :@size=>1,
       :@rest=>{:fixnumliteral=>{:@line=>1, :@value=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "[1, *c()]"' do
    ruby = '[1, *c()]'
    ast  = {:concatargs=>
      {:@array=>
        {:arrayliteral=>
          {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}], :@line=>1}},
       :@size=>1,
       :@rest=>
        {:send=>
          {:@block=>nil,
           :@name=>:c,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "x = [2]; [1, *x]"' do
    ruby = 'x = [2]; [1, *x]'
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:x,
            :@line=>1,
            :@value=>
             {:arrayliteral=>
               {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>2}}], :@line=>1}}}},
         {:concatargs=>
           {:@array=>
             {:arrayliteral=>
               {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}], :@line=>1}},
            :@size=>1,
            :@rest=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:x, :@line=>1}},
            :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
