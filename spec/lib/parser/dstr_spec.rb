require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "#{}"' do
    ruby = '"#{}"'
    ast  = {:dynamicstring=>
      {:@string=>:"<blank>",
       :@array=>[{:stringliteral=>{:@string=>:"<blank>", :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "#{}#{}"' do
    ruby = '"#{}#{}"'
    ast  = {:dynamicstring=>
      {:@string=>:"<blank>",
       :@array=>
        [{:stringliteral=>{:@string=>:"<blank>", :@line=>1}},
         {:stringliteral=>{:@string=>:"<blank>", :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "#{}hello#{}"' do
    ruby = '"#{}hello#{}"'
    ast  = {:dynamicstring=>
      {:@string=>:"<blank>",
       :@array=>
        [{:stringliteral=>{:@string=>:"<blank>", :@line=>1}},
         {:stringliteral=>{:@string=>:hello, :@line=>1}},
         {:stringliteral=>{:@string=>:"<blank>", :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "hello #{}"' do
    ruby = '"hello #{}"'
    ast  = {:dynamicstring=>
      {:@string=>:"hello ",
       :@array=>[{:stringliteral=>{:@string=>:"<blank>", :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "#{} hello"' do
    ruby = '"#{} hello"'
    ast  = {:dynamicstring=>
      {:@string=>:"<blank>",
       :@array=>
        [{:stringliteral=>{:@string=>:"<blank>", :@line=>1}},
         {:stringliteral=>{:@string=>:" hello", :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "#{a}"' do
    ruby = '"#{a}"'
    ast  = {:dynamicstring=>
      {:@string=>:"<blank>",
       :@array=>
        [{:tostring=>
           {:@line=>1,
            :@value=>
             {:send=>
               {:@block=>nil,
                :@name=>:a,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "hello #{a}"' do
    ruby = '"hello #{a}"'
    ast  = {:dynamicstring=>
      {:@string=>:"hello ",
       :@array=>
        [{:tostring=>
           {:@line=>1,
            :@value=>
             {:send=>
               {:@block=>nil,
                :@name=>:a,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "#{a} hello"' do
    ruby = '"#{a} hello"'
    ast  = {:dynamicstring=>
      {:@string=>:"<blank>",
       :@array=>
        [{:tostring=>
           {:@line=>1,
            :@value=>
             {:send=>
               {:@block=>nil,
                :@name=>:a,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}}},
         {:stringliteral=>{:@string=>:" hello", :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "argl = 1; "x#{argl}y""' do
    ruby = <<-ruby
        argl = 1
        "x\#{argl}y"
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:argl,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:dynamicstring=>
           {:@string=>:x,
            :@array=>
             [{:tostring=>
                {:@line=>2,
                 :@value=>
                  {:localvariableaccess=>
                    {:@variable=>nil, :@name=>:argl, :@line=>2}}}},
              {:stringliteral=>{:@string=>:y, :@line=>2}}],
            :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "argl = 1; "x#{("%.2f" % 3.14159)}y""' do
    ruby = <<-ruby
        argl = 1
        "x\#{("%.2f" % 3.14159)}y"
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:argl,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:dynamicstring=>
           {:@string=>:x,
            :@array=>
             [{:tostring=>
                {:@line=>2,
                 :@value=>
                  {:sendwitharguments=>
                    {:@block=>nil,
                     :@name=>:%,
                     :@line=>2,
                     :@privately=>false,
                     :@receiver=>{:stringliteral=>{:@string=>:"%.2f", :@line=>2}},
                     :@check_for_local=>false,
                     :@arguments=>
                      {:actualarguments=>
                        {:@array=>[{:float=>{:@line=>2, :@value=>:"3.14159"}}],
                         :@splat=>nil,
                         :@line=>2}}}}}},
              {:stringliteral=>{:@string=>:y, :@line=>2}}],
            :@line=>2}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "max = 2; argl = 1; "x#{("%.#{max}f" % 3.14159)}y" # ""' do
    ruby = <<-ruby
        max = 2
        argl = 1
        "x\#{("%.\#{max}f" % 3.14159)}y" # "
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:max,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>2}}}},
         {:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:argl,
            :@line=>2,
            :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}},
         {:dynamicstring=>
           {:@string=>:x,
            :@array=>
             [{:tostring=>
                {:@line=>3,
                 :@value=>
                  {:sendwitharguments=>
                    {:@block=>nil,
                     :@name=>:%,
                     :@line=>3,
                     :@privately=>false,
                     :@receiver=>
                      {:dynamicstring=>
                        {:@string=>:"%.",
                         :@array=>
                          [{:tostring=>
                             {:@line=>3,
                              :@value=>
                               {:localvariableaccess=>
                                 {:@variable=>nil, :@name=>:max, :@line=>3}}}},
                           {:stringliteral=>{:@string=>:f, :@line=>3}}],
                         :@line=>3}},
                     :@check_for_local=>false,
                     :@arguments=>
                      {:actualarguments=>
                        {:@array=>[{:float=>{:@line=>3, :@value=>:"3.14159"}}],
                         :@splat=>nil,
                         :@line=>3}}}}}},
              {:stringliteral=>{:@string=>:y, :@line=>3}}],
            :@line=>3}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "#{22}aa" "cd#{44}" "55" "#{66}""' do
    ruby = '"#{22}aa" "cd#{44}" "55" "#{66}"'
    ast  = {:dynamicstring=>
      {:@string=>:"<blank>",
       :@array=>
        [{:tostring=>
           {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>22}}}},
         {:stringliteral=>{:@string=>:aa, :@line=>1}},
         {:stringliteral=>{:@string=>:cd, :@line=>1}},
         {:tostring=>
           {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>44}}}},
         {:stringliteral=>{:@string=>:"55", :@line=>1}},
         {:tostring=>
           {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>66}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a #$global b #@ivar c #@@cvar d"' do
    ruby = '"a #$global b #@ivar c #@@cvar d"'
    ast  = {:dynamicstring=>
      {:@string=>:"a ",
       :@array=>
        [{:tostring=>
           {:@line=>1,
            :@value=>{:globalvariableaccess=>{:@name=>:$global, :@line=>1}}}},
         {:stringliteral=>{:@string=>:" b ", :@line=>1}},
         {:tostring=>
           {:@line=>1,
            :@value=>{:instancevariableaccess=>{:@name=>:@ivar, :@line=>1}}}},
         {:stringliteral=>{:@string=>:" c ", :@line=>1}},
         {:tostring=>
           {:@line=>1,
            :@value=>{:classvariableaccess=>{:@name=>:@@cvar, :@line=>1}}}},
         {:stringliteral=>{:@string=>:" d", :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "<<EOM ..."' do
    ruby = <<-ruby
<<EOM
  foo
\#{1 + 1}blah
EOM
      ruby
    ast  = {:dynamicstring=>
      {:@string=>:"  foo\n",
       :@array=>
        [{:tostring=>
           {:@line=>3,
            :@value=>
             {:sendwitharguments=>
               {:@block=>nil,
                :@name=>:+,
                :@line=>3,
                :@privately=>false,
                :@receiver=>{:fixnumliteral=>{:@line=>3, :@value=>1}},
                :@check_for_local=>false,
                :@arguments=>
                 {:actualarguments=>
                   {:@array=>[{:fixnumliteral=>{:@line=>3, :@value=>1}}],
                    :@splat=>nil,
                    :@line=>3}}}}}},
         {:stringliteral=>{:@string=>:"blah\n", :@line=>1}}],
       :@line=>3}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "<<-EOF ..."' do
    ruby =  <<-ruby
<<-EOF
  def test_\#{action}_valid_feed
EOF
      ruby
    ast  = {:dynamicstring=>
      {:@string=>:"  def test_",
       :@array=>
        [{:tostring=>
           {:@line=>2,
            :@value=>
             {:send=>
               {:@block=>nil,
                :@name=>:action,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false}}}},
         {:stringliteral=>{:@string=>:"_valid_feed\n", :@line=>1}}],
       :@line=>2}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "<<-EOF ..."' do
    ruby = <<-ruby
<<-EOF
  s1 '\#{RUBY_PLATFORM}' s2
  \#{__FILE__}
EOF
      ruby
    ast  = {:dynamicstring=>
      {:@string=>:"  s1 '",
       :@array=>
        [{:tostring=>
           {:@line=>2,
            :@value=>{:constfind=>{:@name=>:RUBY_PLATFORM, :@line=>2}}}},
         {:stringliteral=>{:@string=>:"' s2\n  ", :@line=>3}},
         {:tostring=>{:@line=>3, :@value=>{:file=>{:@line=>3}}}},
         {:stringliteral=>{:@string=>:"\n", :@line=>1}}],
       :@line=>2}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "%Q[before [#{nest}] after]"' do
    ruby = '"%Q[before [#{nest}] after]"'
    ast  = {:dynamicstring=>
      {:@string=>:"%Q[before [",
       :@array=>
        [{:tostring=>
           {:@line=>1,
            :@value=>
             {:send=>
               {:@block=>nil,
                :@name=>:nest,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}}},
         {:stringliteral=>{:@string=>:"] after]", :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "#{"blah"}#{__FILE__}:#{__LINE__}: warning: #{$!.message} (#{$!.class})"' do
    ruby = '"#{"blah"}#{__FILE__}:#{__LINE__}: warning: #{$!.message} (#{$!.class})"'
    ast  = {:dynamicstring=>
      {:@string=>:blah,
       :@array=>
        [{:tostring=>{:@line=>1, :@value=>{:file=>{:@line=>1}}}},
         {:stringliteral=>{:@string=>:":", :@line=>1}},
         {:tostring=>
           {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:stringliteral=>{:@string=>:": warning: ", :@line=>1}},
         {:tostring=>
           {:@line=>1,
            :@value=>
             {:send=>
               {:@block=>nil,
                :@name=>:message,
                :@line=>1,
                :@privately=>false,
                :@receiver=>{:globalvariableaccess=>{:@name=>:$!, :@line=>1}},
                :@check_for_local=>false}}}},
         {:stringliteral=>{:@string=>:" (", :@line=>1}},
         {:tostring=>
           {:@line=>1,
            :@value=>
             {:send=>
               {:@block=>nil,
                :@name=>:class,
                :@line=>1,
                :@privately=>false,
                :@receiver=>{:globalvariableaccess=>{:@name=>:$!, :@line=>1}},
                :@check_for_local=>false}}}},
         {:stringliteral=>{:@string=>:")", :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "before #{from} middle #{to} (#{__FILE__}:#{__LINE__})"' do
    ruby = '"before #{from} middle #{to} (#{__FILE__}:#{__LINE__})"'
    ast  = {:dynamicstring=>
      {:@string=>:"before ",
       :@array=>
        [{:tostring=>
           {:@line=>1,
            :@value=>
             {:send=>
               {:@block=>nil,
                :@name=>:from,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}}},
         {:stringliteral=>{:@string=>:" middle ", :@line=>1}},
         {:tostring=>
           {:@line=>1,
            :@value=>
             {:send=>
               {:@block=>nil,
                :@name=>:to,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}}},
         {:stringliteral=>{:@string=>:" (", :@line=>1}},
         {:tostring=>{:@line=>1, :@value=>{:file=>{:@line=>1}}}},
         {:stringliteral=>{:@string=>:":", :@line=>1}},
         {:tostring=>
           {:@line=>1, :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:stringliteral=>{:@string=>:")", :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
