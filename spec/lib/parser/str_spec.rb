require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "x"' do
    ruby = 'x'
    ast  = {:send=>
      {:@block=>nil,
       :@name=>:x,
       :@line=>1,
       :@privately=>true,
       :@receiver=>{:self=>{:@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse ""before" \ ..."' do
    ruby = <<-ruby
        "before" \
        " after"
      ruby
    ast  = {:stringliteral=>{:@string=>:"before after", :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse ""before" " after""' do
    ruby = '"before" " after"'
    ast  = {:stringliteral=>{:@string=>:"before after", :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse ""file = #{__FILE__}\n""' do
    ruby = <<-ruby
        "file = \#{__FILE__}\n"
      ruby
    ast  = {:dynamicstring=>
      {:@string=>:"file = ",
       :@array=>
        [{:tostring=>{:@line=>1, :@value=>{:file=>{:@line=>1}}}},
         {:stringliteral=>{:@string=>:"\n", :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "<<\'EOM\'.strip ..."' do
    ruby = <<-ruby
<<'EOM'.strip
  blah
  blah
EOM
      ruby
    ast  = {:send=>
      {:@block=>nil,
       :@name=>:strip,
       :@line=>1,
       :@privately=>false,
       :@receiver=>{:stringliteral=>{:@string=>:"  blah\n  blah\n", :@line=>1}},
       :@check_for_local=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a += <<-H1 + b + <<-H2 ..."' do
    ruby = <<-ruby
a += <<-H1 + b + <<-H2
  first
H1
  second
H2
      ruby
    ast  = {:localvariableassignment=>
      {:@variable=>nil,
       :@name=>:a,
       :@line=>1,
       :@value=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:+,
           :@line=>1,
           :@privately=>false,
           :@receiver=>
            {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>1}},
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>
                [{:sendwitharguments=>
                   {:@block=>nil,
                    :@name=>:+,
                    :@line=>1,
                    :@privately=>false,
                    :@receiver=>
                     {:sendwitharguments=>
                       {:@block=>nil,
                        :@name=>:+,
                        :@line=>1,
                        :@privately=>false,
                        :@receiver=>
                         {:stringliteral=>{:@string=>:"  first\n", :@line=>1}},
                        :@check_for_local=>false,
                        :@arguments=>
                         {:actualarguments=>
                           {:@array=>
                             [{:send=>
                                {:@block=>nil,
                                 :@name=>:b,
                                 :@line=>1,
                                 :@privately=>true,
                                 :@receiver=>{:self=>{:@line=>1}},
                                 :@check_for_local=>false}}],
                            :@splat=>nil,
                            :@line=>1}}}},
                    :@check_for_local=>false,
                    :@arguments=>
                     {:actualarguments=>
                       {:@array=>
                         [{:stringliteral=>{:@string=>:"  second\n", :@line=>1}}],
                        :@splat=>nil,
                        :@line=>1}}}}],
               :@splat=>nil,
               :@line=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "<<-EOM ..."' do
    ruby = <<-ruby
<<-EOM
  blah
blah

EOM
      ruby
    ast  = {:stringliteral=>{:@string=>:"  blah\nblah\n\n", :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "<<\'EOM\' ..."' do
    ruby = <<-ruby
<<'EOM'
  blah
blah
EOM
      ruby
    ast  = {:stringliteral=>{:@string=>:"  blah\nblah\n", :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "%(blah)"' do
    ruby = '%(blah)'
    ast  = {:stringliteral=>{:@string=>:blah, :@line=>1}}

    ruby.should parse_as(ast)
  end

end
