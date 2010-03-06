require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "undef :x"' do
    ruby = 'undef :x'
    ast  = {:undef=>{:@name=>{:symbolliteral=>{:@line=>1, :@value=>:x}}, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "undef :x, :y"' do
    ruby = 'undef :x, :y'
    ast  = {:block=>
      {:@array=>
        [{:undef=>{:@name=>{:symbolliteral=>{:@line=>1, :@value=>:x}}, :@line=>1}},
         {:undef=>
           {:@name=>{:symbolliteral=>{:@line=>1, :@value=>:y}}, :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "undef :x, :y, :z"' do
    ruby = 'undef :x, :y, :z'
    ast  = {:block=>
      {:@array=>
        [{:undef=>{:@name=>{:symbolliteral=>{:@line=>1, :@value=>:x}}, :@line=>1}},
         {:undef=>{:@name=>{:symbolliteral=>{:@line=>1, :@value=>:y}}, :@line=>1}},
         {:undef=>
           {:@name=>{:symbolliteral=>{:@line=>1, :@value=>:z}}, :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "f1; undef :x"' do
    ruby = <<-ruby
        f1
        undef :x
      ruby
    ast  = {:block=>
      {:@array=>
        [{:send=>
           {:@block=>nil,
            :@name=>:f1,
            :@line=>1,
            :@privately=>true,
            :@receiver=>{:self=>{:@line=>1}},
            :@check_for_local=>false}},
         {:undef=>
           {:@name=>{:symbolliteral=>{:@line=>2, :@value=>:x}}, :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "f1; undef :x, :y"' do
    ruby = <<-ruby
        f1
        undef :x, :y
      ruby
    ast  = {:block=>
      {:@array=>
        [{:send=>
           {:@block=>nil,
            :@name=>:f1,
            :@line=>1,
            :@privately=>true,
            :@receiver=>{:self=>{:@line=>1}},
            :@check_for_local=>false}},
         {:block=>
           {:@array=>
             [{:undef=>
                {:@name=>{:symbolliteral=>{:@line=>2, :@value=>:x}}, :@line=>2}},
              {:undef=>
                {:@name=>{:symbolliteral=>{:@line=>2, :@value=>:y}}, :@line=>2}}],
            :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "undef :x, :y, :z; f2"' do
    ruby = <<-ruby
        undef :x, :y, :z
        f2
      ruby
    ast  = {:block=>
      {:@array=>
        [{:undef=>{:@name=>{:symbolliteral=>{:@line=>1, :@value=>:x}}, :@line=>1}},
         {:undef=>{:@name=>{:symbolliteral=>{:@line=>1, :@value=>:y}}, :@line=>1}},
         {:undef=>{:@name=>{:symbolliteral=>{:@line=>1, :@value=>:z}}, :@line=>1}},
         {:send=>
           {:@block=>nil,
            :@name=>:f2,
            :@line=>2,
            :@privately=>true,
            :@receiver=>{:self=>{:@line=>2}},
            :@check_for_local=>false}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "f1; undef :x, :y, :z"' do
    ruby = <<-ruby
        f1
        undef :x, :y, :z
      ruby
    ast  = {:block=>
      {:@array=>
        [{:send=>
           {:@block=>nil,
            :@name=>:f1,
            :@line=>1,
            :@privately=>true,
            :@receiver=>{:self=>{:@line=>1}},
            :@check_for_local=>false}},
         {:block=>
           {:@array=>
             [{:undef=>
                {:@name=>{:symbolliteral=>{:@line=>2, :@value=>:x}}, :@line=>2}},
              {:undef=>
                {:@name=>{:symbolliteral=>{:@line=>2, :@value=>:y}}, :@line=>2}},
              {:undef=>
                {:@name=>{:symbolliteral=>{:@line=>2, :@value=>:z}}, :@line=>2}}],
            :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "f1; undef :x, :y, :z; f2"' do
    ruby = <<-ruby
        f1
        undef :x, :y, :z
        f2
      ruby
    ast  = {:block=>
      {:@array=>
        [{:send=>
           {:@block=>nil,
            :@name=>:f1,
            :@line=>1,
            :@privately=>true,
            :@receiver=>{:self=>{:@line=>1}},
            :@check_for_local=>false}},
         {:block=>
           {:@array=>
             [{:undef=>
                {:@name=>{:symbolliteral=>{:@line=>2, :@value=>:x}}, :@line=>2}},
              {:undef=>
                {:@name=>{:symbolliteral=>{:@line=>2, :@value=>:y}}, :@line=>2}},
              {:undef=>
                {:@name=>{:symbolliteral=>{:@line=>2, :@value=>:z}}, :@line=>2}}],
            :@line=>2}},
         {:send=>
           {:@block=>nil,
            :@name=>:f2,
            :@line=>3,
            :@privately=>true,
            :@receiver=>{:self=>{:@line=>3}},
            :@check_for_local=>false}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "class B; undef :blah; end"' do
    ruby = 'class B; undef :blah; end'
    ast  = {:class=>
      {:@superclass=>{},
       :@body=>
        {:classscope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:undef=>
                   {:@name=>{:symbolliteral=>{:@line=>1, :@value=>:blah}},
                    :@line=>1}}],
               :@line=>1}},
           :@name=>:B,
           :@line=>1}},
       :@name=>{:classname=>{:@superclass=>{}, :@name=>:B, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "undef :"x#{1}", :"x#{2}""' do
    ruby = <<-ruby
        undef :"x\#{1}", :"x\#{2}"
      ruby
    ast  = {:block=>
      {:@array=>
        [{:undef=>
           {:@name=>
             {:dynamicsymbol=>
               {:@string=>:x,
                :@array=>
                 [{:tostring=>
                    {:@line=>1,
                     :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}],
                :@line=>1}},
            :@line=>1}},
         {:undef=>
           {:@name=>
             {:dynamicsymbol=>
               {:@string=>:x,
                :@array=>
                 [{:tostring=>
                    {:@line=>1,
                     :@value=>{:fixnumliteral=>{:@line=>1, :@value=>2}}}}],
                :@line=>1}},
            :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
