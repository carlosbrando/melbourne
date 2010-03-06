require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "return"' do
    ruby = 'return'
    ast  = {:return=>{:@splat=>nil, :@line=>1, :@value=>nil}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "return 1"' do
    ruby = 'return 1'
    ast  = {:return=>
      {:@splat=>nil,
       :@line=>1,
       :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "return *1"' do
    ruby = 'return *1'
    ast  = {:return=>
      {:@splat=>nil,
       :@line=>1,
       :@value=>
        {:svalue=>
          {:@line=>1,
           :@value=>
            {:splatvalue=>
              {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "x = 1, 2; return *x"' do
    ruby = <<-ruby
        x = 1, 2
        return *x
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:x,
            :@line=>1,
            :@value=>
             {:svalue=>
               {:@line=>1,
                :@value=>
                 {:arrayliteral=>
                   {:@body=>
                     [{:fixnumliteral=>{:@line=>1, :@value=>1}},
                      {:fixnumliteral=>{:@line=>1, :@value=>2}}],
                    :@line=>1}}}}}},
         {:return=>
           {:@splat=>nil,
            :@line=>2,
            :@value=>
             {:svalue=>
               {:@line=>2,
                :@value=>
                 {:splatvalue=>
                   {:@line=>2,
                    :@value=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:x, :@line=>2}}}}}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "return 1, 2, 3"' do
    ruby = 'return 1, 2, 3'
    ast  = {:return=>
      {:@splat=>nil,
       :@line=>1,
       :@value=>
        {:arrayliteral=>
          {:@body=>
            [{:fixnumliteral=>{:@line=>1, :@value=>1}},
             {:fixnumliteral=>{:@line=>1, :@value=>2}},
             {:fixnumliteral=>{:@line=>1, :@value=>3}}],
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "return 1, 2, *c"' do
    ruby = 'return 1, 2, *c'
    ast  = {:return=>
      {:@splat=>nil,
       :@line=>1,
       :@value=>
        {:concatargs=>
          {:@array=>
            {:arrayliteral=>
              {:@body=>
                [{:fixnumliteral=>{:@line=>1, :@value=>1}},
                 {:fixnumliteral=>{:@line=>1, :@value=>2}}],
               :@line=>1}},
           :@size=>2,
           :@rest=>
            {:send=>
              {:@block=>nil,
               :@name=>:c,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "return [*[1]]"' do
    ruby = 'return [*[1]]'
    ast  = {:return=>
      {:@splat=>nil,
       :@line=>1,
       :@value=>
        {:splatvalue=>
          {:@line=>1,
           :@value=>
            {:arrayliteral=>
              {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}], :@line=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "return *[1]"' do
    ruby = 'return *[1]'
    ast  = {:return=>
      {:@splat=>nil,
       :@line=>1,
       :@value=>
        {:svalue=>
          {:@line=>1,
           :@value=>
            {:splatvalue=>
              {:@line=>1,
               :@value=>
                {:arrayliteral=>
                  {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                   :@line=>1}}}}}}}}

    ruby.should parse_as(ast)
  end

end
