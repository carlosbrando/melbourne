require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "a &&= 8"' do
    ruby = 'a &&= 8'
    ast  = {:opassignand=>
      {:@line=>1,
       :@left=>{:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>1}},
       :@right=>
        {:localvariableassignment=>
          {:@variable=>nil,
           :@name=>:a,
           :@line=>1,
           :@value=>{:fixnumliteral=>{:@line=>1, :@value=>8}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "hsh[:blah] ||= 8"' do
    ruby = 'hsh[:blah] ||= 8'
    ast  = {:opassign1=>
      {:@op=>:or,
       :@index=>[{:symbolliteral=>{:@line=>1, :@value=>:blah}}],
       :@line=>1,
       :@value=>{:fixnumliteral=>{:@line=>1, :@value=>8}},
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:hsh,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "x = 1; hsh[x] ||= 8"' do
    ruby = <<-ruby
        x = 1
        hsh[x] ||= 8
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:x,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:opassign1=>
           {:@op=>:or,
            :@index=>
             [{:localvariableaccess=>{:@variable=>nil, :@name=>:x, :@line=>2}}],
            :@line=>2,
            :@value=>{:fixnumliteral=>{:@line=>2, :@value=>8}},
            :@receiver=>
             {:send=>
               {:@block=>nil,
                :@name=>:hsh,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "hsh[:blah] &&= 8"' do
    ruby = 'hsh[:blah] &&= 8'
    ast  = {:opassign1=>
      {:@op=>:and,
       :@index=>[{:symbolliteral=>{:@line=>1, :@value=>:blah}}],
       :@line=>1,
       :@value=>{:fixnumliteral=>{:@line=>1, :@value=>8}},
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:hsh,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "hsh[:blah] ^= 8"' do
    ruby = 'hsh[:blah] ^= 8'
    ast  = {:opassign1=>
      {:@op=>:^,
       :@index=>[{:symbolliteral=>{:@line=>1, :@value=>:blah}}],
       :@line=>1,
       :@value=>{:fixnumliteral=>{:@line=>1, :@value=>8}},
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:hsh,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "ary[0,1] += [4]"' do
    ruby = 'ary[0,1] += [4]'
    ast  = {:opassign1=>
      {:@op=>:+,
       :@index=>
        [{:fixnumliteral=>{:@line=>1, :@value=>0}},
         {:fixnumliteral=>{:@line=>1, :@value=>1}}],
       :@line=>1,
       :@value=>
        {:arrayliteral=>
          {:@body=>[{:fixnumliteral=>{:@line=>1, :@value=>4}}], :@line=>1}},
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:ary,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "x.val ||= 6"' do
    ruby = 'x.val ||= 6'
    ast  = {:opassign2=>
      {:@op=>:or,
       :@assign=>:val=,
       :@name=>:val,
       :@line=>1,
       :@value=>{:fixnumliteral=>{:@line=>1, :@value=>6}},
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:x,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "x.val &&= 7"' do
    ruby = 'x.val &&= 7'
    ast  = {:opassign2=>
      {:@op=>:and,
       :@assign=>:val=,
       :@name=>:val,
       :@line=>1,
       :@value=>{:fixnumliteral=>{:@line=>1, :@value=>7}},
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:x,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "@b = []; @b[1] ||= 10; @b[2] &&= 11; @b[3] += 12"' do
    ruby = <<-ruby
        @b = []
        @b[1] ||= 10
        @b[2] &&= 11
        @b[3] += 12
      ruby
    ast  = {:block=>
      {:@array=>
        [{:instancevariableassignment=>
           {:@name=>:@b, :@line=>1, :@value=>{:emptyarray=>{:@line=>1}}}},
         {:opassign1=>
           {:@op=>:or,
            :@index=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
            :@line=>2,
            :@value=>{:fixnumliteral=>{:@line=>2, :@value=>10}},
            :@receiver=>{:instancevariableaccess=>{:@name=>:@b, :@line=>2}}}},
         {:opassign1=>
           {:@op=>:and,
            :@index=>[{:fixnumliteral=>{:@line=>3, :@value=>2}}],
            :@line=>3,
            :@value=>{:fixnumliteral=>{:@line=>3, :@value=>11}},
            :@receiver=>{:instancevariableaccess=>{:@name=>:@b, :@line=>3}}}},
         {:opassign1=>
           {:@op=>:+,
            :@index=>[{:fixnumliteral=>{:@line=>4, :@value=>3}}],
            :@line=>4,
            :@value=>{:fixnumliteral=>{:@line=>4, :@value=>12}},
            :@receiver=>{:instancevariableaccess=>{:@name=>:@b, :@line=>4}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "b = []; b[1] ||= 10; b[2] &&= 11; b[3] += 12"' do
    ruby = <<-ruby
        b = []
        b[1] ||= 10
        b[2] &&= 11
        b[3] += 12
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:b,
            :@line=>1,
            :@value=>{:emptyarray=>{:@line=>1}}}},
         {:opassign1=>
           {:@op=>:or,
            :@index=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
            :@line=>2,
            :@value=>{:fixnumliteral=>{:@line=>2, :@value=>10}},
            :@receiver=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:b, :@line=>2}}}},
         {:opassign1=>
           {:@op=>:and,
            :@index=>[{:fixnumliteral=>{:@line=>3, :@value=>2}}],
            :@line=>3,
            :@value=>{:fixnumliteral=>{:@line=>3, :@value=>11}},
            :@receiver=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:b, :@line=>3}}}},
         {:opassign1=>
           {:@op=>:+,
            :@index=>[{:fixnumliteral=>{:@line=>4, :@value=>3}}],
            :@line=>4,
            :@value=>{:fixnumliteral=>{:@line=>4, :@value=>12}},
            :@receiver=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:b, :@line=>4}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "x.val ^= 8"' do
    ruby = 'x.val ^= 8'
    ast  = {:opassign2=>
      {:@op=>:^,
       :@assign=>:val=,
       :@name=>:val,
       :@line=>1,
       :@value=>{:fixnumliteral=>{:@line=>1, :@value=>8}},
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:x,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "self.Bag ||= Bag.new"' do
    ruby = 'self.Bag ||= Bag.new'
    ast  = {:opassign2=>
      {:@op=>:or,
       :@assign=>:"Bag=",
       :@name=>:Bag,
       :@line=>1,
       :@value=>
        {:send=>
          {:@block=>nil,
           :@name=>:new,
           :@line=>1,
           :@privately=>false,
           :@receiver=>{:constfind=>{:@name=>:Bag, :@line=>1}},
           :@check_for_local=>false}},
       :@receiver=>{:self=>{:@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "s = Struct.new(:var); c = s.new(nil); c.var ||= 20; c.var &&= 21; c.var += 22; c.d.e.f ||= 42"' do
    ruby = <<-ruby
        s = Struct.new(:var)
        c = s.new(nil)
        c.var ||= 20
        c.var &&= 21
        c.var += 22
        c.d.e.f ||= 42
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:s,
            :@line=>1,
            :@value=>
             {:sendwitharguments=>
               {:@block=>nil,
                :@name=>:new,
                :@line=>1,
                :@privately=>false,
                :@receiver=>{:constfind=>{:@name=>:Struct, :@line=>1}},
                :@check_for_local=>false,
                :@arguments=>
                 {:actualarguments=>
                   {:@array=>[{:symbolliteral=>{:@line=>1, :@value=>:var}}],
                    :@splat=>nil,
                    :@line=>1}}}}}},
         {:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:c,
            :@line=>2,
            :@value=>
             {:sendwitharguments=>
               {:@block=>nil,
                :@name=>:new,
                :@line=>2,
                :@privately=>false,
                :@receiver=>
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:s, :@line=>2}},
                :@check_for_local=>false,
                :@arguments=>
                 {:actualarguments=>{:@array=>[{}], :@splat=>nil, :@line=>2}}}}}},
         {:opassign2=>
           {:@op=>:or,
            :@assign=>:var=,
            :@name=>:var,
            :@line=>3,
            :@value=>{:fixnumliteral=>{:@line=>3, :@value=>20}},
            :@receiver=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:c, :@line=>3}}}},
         {:opassign2=>
           {:@op=>:and,
            :@assign=>:var=,
            :@name=>:var,
            :@line=>4,
            :@value=>{:fixnumliteral=>{:@line=>4, :@value=>21}},
            :@receiver=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:c, :@line=>4}}}},
         {:opassign2=>
           {:@op=>:+,
            :@assign=>:var=,
            :@name=>:var,
            :@line=>5,
            :@value=>{:fixnumliteral=>{:@line=>5, :@value=>22}},
            :@receiver=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:c, :@line=>5}}}},
         {:opassign2=>
           {:@op=>:or,
            :@assign=>:f=,
            :@name=>:f,
            :@line=>6,
            :@value=>{:fixnumliteral=>{:@line=>6, :@value=>42}},
            :@receiver=>
             {:send=>
               {:@block=>nil,
                :@name=>:e,
                :@line=>6,
                :@privately=>false,
                :@receiver=>
                 {:send=>
                   {:@block=>nil,
                    :@name=>:d,
                    :@line=>6,
                    :@privately=>false,
                    :@receiver=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:c, :@line=>6}},
                    :@check_for_local=>false}},
                :@check_for_local=>false}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "@fetcher &&= new(Gem.configuration[:http_proxy])"' do
    ruby = '@fetcher &&= new(Gem.configuration[:http_proxy])'
    ast  = {:opassignand=>
      {:@line=>1,
       :@left=>{:instancevariableaccess=>{:@name=>:@fetcher, :@line=>1}},
       :@right=>
        {:instancevariableassignment=>
          {:@name=>:@fetcher,
           :@line=>1,
           :@value=>
            {:sendwitharguments=>
              {:@block=>nil,
               :@name=>:new,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>
                    [{:sendwitharguments=>
                       {:@block=>nil,
                        :@name=>:[],
                        :@line=>1,
                        :@privately=>false,
                        :@receiver=>
                         {:send=>
                           {:@block=>nil,
                            :@name=>:configuration,
                            :@line=>1,
                            :@privately=>false,
                            :@receiver=>{:constfind=>{:@name=>:Gem, :@line=>1}},
                            :@check_for_local=>false}},
                        :@check_for_local=>false,
                        :@arguments=>
                         {:actualarguments=>
                           {:@array=>
                             [{:symbolliteral=>{:@line=>1, :@value=>:http_proxy}}],
                            :@splat=>nil,
                            :@line=>1}}}}],
                   :@splat=>nil,
                   :@line=>1}}}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = 0; a &&= 2"' do
    ruby = <<-ruby
        a = 0
        a &&= 2
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>0}}}},
         {:opassignand=>
           {:@line=>2,
            :@left=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
            :@right=>
             {:localvariableassignment=>
               {:@variable=>nil,
                :@name=>:a,
                :@line=>2,
                :@value=>{:fixnumliteral=>{:@line=>2, :@value=>2}}}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "@@var ||= 3"' do
    ruby = '@@var ||= 3'
    ast  = {:opassignor=>
      {:@line=>1,
       :@left=>{:classvariableaccess=>{:@name=>:@@var, :@line=>1}},
       :@right=>
        {:classvariableassignment=>
          {:@name=>:@@var,
           :@line=>1,
           :@value=>{:fixnumliteral=>{:@line=>1, :@value=>3}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a ||= 8"' do
    ruby = 'a ||= 8'
    ast  = {:opassignor=>
      {:@line=>1,
       :@left=>{:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>1}},
       :@right=>
        {:localvariableassignment=>
          {:@variable=>nil,
           :@name=>:a,
           :@line=>1,
           :@value=>{:fixnumliteral=>{:@line=>1, :@value=>8}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a ||= begin ..."' do
    ruby = <<-ruby
        a ||= begin
                b
              rescue
                c
              end
      ruby
    ast  = {:opassignor=>
      {:@line=>5,
       :@left=>{:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>5}},
       :@right=>
        {:localvariableassignment=>
          {:@variable=>nil,
           :@name=>:a,
           :@line=>1,
           :@value=>
            {:rescue=>
              {:@body=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:b,
                   :@line=>2,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>2}},
                   :@check_for_local=>false}},
               :@rescue=>
                {:rescuecondition=>
                  {:@conditions=>
                    {:arrayliteral=>
                      {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>4}}],
                       :@line=>4}},
                   :@body=>
                    {:send=>
                      {:@block=>nil,
                       :@name=>:c,
                       :@line=>4,
                       :@privately=>true,
                       :@receiver=>{:self=>{:@line=>4}},
                       :@check_for_local=>false}},
                   :@splat=>nil,
                   :@next=>nil,
                   :@line=>4,
                   :@assignment=>nil}},
               :@else=>nil,
               :@line=>2}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "@fetcher ||= new(Gem.configuration[:http_proxy])"' do
    ruby = '@fetcher ||= new(Gem.configuration[:http_proxy])'
    ast  = {:opassignor=>
      {:@line=>1,
       :@left=>{:instancevariableaccess=>{:@name=>:@fetcher, :@line=>1}},
       :@right=>
        {:instancevariableassignment=>
          {:@name=>:@fetcher,
           :@line=>1,
           :@value=>
            {:sendwitharguments=>
              {:@block=>nil,
               :@name=>:new,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false,
               :@arguments=>
                {:actualarguments=>
                  {:@array=>
                    [{:sendwitharguments=>
                       {:@block=>nil,
                        :@name=>:[],
                        :@line=>1,
                        :@privately=>false,
                        :@receiver=>
                         {:send=>
                           {:@block=>nil,
                            :@name=>:configuration,
                            :@line=>1,
                            :@privately=>false,
                            :@receiver=>{:constfind=>{:@name=>:Gem, :@line=>1}},
                            :@check_for_local=>false}},
                        :@check_for_local=>false,
                        :@arguments=>
                         {:actualarguments=>
                           {:@array=>
                             [{:symbolliteral=>{:@line=>1, :@value=>:http_proxy}}],
                            :@splat=>nil,
                            :@line=>1}}}}],
                   :@splat=>nil,
                   :@line=>1}}}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "@v ||= {  }"' do
    ruby = '@v ||= {  }'
    ast  = {:opassignor=>
      {:@line=>1,
       :@left=>{:instancevariableaccess=>{:@name=>:@v, :@line=>1}},
       :@right=>
        {:instancevariableassignment=>
          {:@name=>:@v,
           :@line=>1,
           :@value=>{:hashliteral=>{:@array=>[], :@line=>1}}}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = 0; a ||= 1"' do
    ruby = <<-ruby
        a = 0
        a ||= 1
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>0}}}},
         {:opassignor=>
           {:@line=>2,
            :@left=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
            :@right=>
             {:localvariableassignment=>
               {:@variable=>nil,
                :@name=>:a,
                :@line=>2,
                :@value=>{:fixnumliteral=>{:@line=>2, :@value=>1}}}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
