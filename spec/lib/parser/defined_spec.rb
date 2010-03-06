require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "defined? $x"' do
    ruby = 'defined? $x'
    ast  = {:defined=>
      {:@expression=>{:globalvariableaccess=>{:@name=>:$x, :@line=>1}}, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? a"' do
    ruby = 'defined? a'
    ast  = {:defined=>
      {:@expression=>
        {:send=>
          {:@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false,
           :@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = 1; defined? a"' do
    ruby = <<-ruby
        a = 1
        defined? a
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:defined=>
           {:@expression=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
            :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? x = 1"' do
    ruby = 'defined? x = 1'
    ast  = {:defined=>
      {:@expression=>
        {:localvariableassignment=>
          {:@variable=>nil,
           :@name=>:x,
           :@line=>1,
           :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? x += 1"' do
    ruby = 'defined? x += 1'
    ast  = {:defined=>
      {:@expression=>
        {:localvariableassignment=>
          {:@variable=>nil,
           :@name=>:x,
           :@line=>1,
           :@value=>
            {:sendwitharguments=>
              {:@receiver=>
                {:localvariableaccess=>{:@variable=>nil, :@name=>:x, :@line=>1}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
                   :@splat=>nil,
                   :@line=>1}},
               :@block=>nil,
               :@name=>:+,
               :@line=>1,
               :@privately=>false}}}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? x ||= 1"' do
    ruby = 'defined? x ||= 1'
    ast  = {:defined=>
      {:@expression=>
        {:opassignor=>
          {:@right=>
            {:localvariableassignment=>
              {:@variable=>nil,
               :@name=>:x,
               :@line=>1,
               :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
           :@line=>1,
           :@left=>
            {:localvariableaccess=>{:@variable=>nil, :@name=>:x, :@line=>1}}}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? x &&= 1"' do
    ruby = 'defined? x &&= 1'
    ast  = {:defined=>
      {:@expression=>
        {:opassignand=>
          {:@right=>
            {:localvariableassignment=>
              {:@variable=>nil,
               :@name=>:x,
               :@line=>1,
               :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
           :@line=>1,
           :@left=>
            {:localvariableaccess=>{:@variable=>nil, :@name=>:x, :@line=>1}}}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? X"' do
    ruby = 'defined? X'
    ast  = {:defined=>{:@expression=>{:constfind=>{:@name=>:X, :@line=>1}}, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? ::X"' do
    ruby = 'defined? ::X'
    ast  = {:defined=>
      {:@expression=>
        {:constattop=>{:@parent=>{:toplevel=>{:@line=>1}}, :@name=>:X, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? X::Y"' do
    ruby = 'defined? X::Y::Z'
    ast  = {:defined=>
      {:@expression=>
        {:constaccess=>
          {:@parent=>
            {:constaccess=>
              {:@parent=>{:constfind=>{:@name=>:X, :@line=>1}},
               :@name=>:Y,
               :@line=>1}},
           :@name=>:Z,
           :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? self::A"' do
    ruby = 'defined? self::A'
    ast  = {:defined=>
      {:@expression=>
        {:constaccess=>{:@parent=>{:self=>{:@line=>1}}, :@name=>:A, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? self"' do
    ruby = 'defined? self'
    ast  = {:defined=>{:@expression=>{:self=>{:@line=>1}}, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? true"' do
    ruby = 'defined? true'
    ast  = {:defined=>{:@expression=>{:true=>{:@line=>1}}, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? false"' do
    ruby = 'defined? false'
    ast  = {:defined=>{:@expression=>{:false=>{:@line=>1}}, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? nil"' do
    ruby = 'defined? nil'
    ast  = {:defined=>{:@expression=>{}, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? @var"' do
    ruby = 'defined? @var'
    ast  = {:defined=>
      {:@expression=>{:instancevariableaccess=>{:@name=>:@var, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? :a"' do
    ruby = 'defined? :a'
    ast  = {:defined=>
      {:@expression=>{:symbolliteral=>{:@line=>1, :@value=>:a}}, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? \'a\'"' do
    ruby = "defined? 'a'"
    ast  = {:defined=>
      {:@expression=>{:stringliteral=>{:@string=>:a, :@line=>1}}, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? 0"' do
    ruby = 'defined? 0'
    ast  = {:defined=>
      {:@expression=>{:fixnumliteral=>{:@line=>1, :@value=>0}}, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? yield"' do
    ruby = 'defined? yield'
    ast  = {:defined=>
      {:@expression=>
        {:yield=>
          {:@arguments=>{:actualarguments=>{:@array=>[], :@splat=>nil, :@line=>1}},
           :@argument_count=>0,
           :@yield_splat=>false,
           :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? A.m"' do
    ruby = 'defined? A.m'
    ast  = {:defined=>
      {:@expression=>
        {:send=>
          {:@receiver=>{:constfind=>{:@name=>:A, :@line=>1}},
           :@check_for_local=>false,
           :@block=>nil,
           :@name=>:m,
           :@line=>1,
           :@privately=>false}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? ::A.m"' do
    ruby = 'defined? ::A.m'
    ast  = {:defined=>
      {:@expression=>
        {:send=>
          {:@receiver=>
            {:constattop=>
              {:@parent=>{:toplevel=>{:@line=>1}}, :@name=>:A, :@line=>1}},
           :@check_for_local=>false,
           :@block=>nil,
           :@name=>:m,
           :@line=>1,
           :@privately=>false}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? A::B.m"' do
    ruby = 'defined? A::B.m'
    ast  = {:defined=>
      {:@expression=>
        {:send=>
          {:@receiver=>
            {:constaccess=>
              {:@parent=>{:constfind=>{:@name=>:A, :@line=>1}},
               :@name=>:B,
               :@line=>1}},
           :@check_for_local=>false,
           :@block=>nil,
           :@name=>:m,
           :@line=>1,
           :@privately=>false}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "defined? a.b"' do
    ruby = 'defined? a.b'
    ast  = {:defined=>
      {:@expression=>
        {:send=>
          {:@receiver=>
            {:send=>
              {:@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false,
               :@block=>nil,
               :@name=>:a,
               :@line=>1,
               :@privately=>true}},
           :@check_for_local=>false,
           :@block=>nil,
           :@name=>:b,
           :@line=>1,
           :@privately=>false}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = 1; defined? a.to_s"' do
    ruby = <<-ruby
        a = 1
        defined? a.to_s
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:defined=>
           {:@expression=>
             {:send=>
               {:@receiver=>
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
                :@check_for_local=>false,
                :@block=>nil,
                :@name=>:to_s,
                :@line=>2,
                :@privately=>false}},
            :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
