require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "case ..."' do
    ruby = <<-ruby
        var = 2
        result = ""
        case var
        when 1 then
          puts("something")
          result = "red"
        when 2, 3 then
          result = "yellow"
        when 4 then
          # do nothing
        else
          result = "green"
        end
        case result
        when "red" then
          var = 1
        when "yellow" then
          var = 2
        when "green" then
          var = 3
        else
          # do nothing
        end
      ruby
    ast = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:var,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>2}}}},
         {:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:result,
            :@line=>2,
            :@value=>{:stringliteral=>{:@string=>:"<blank>", :@line=>2}}}},
         {:receivercase=>
           {:@whens=>
             [{:when=>
                {:@body=>
                  {:block=>
                    {:@array=>
                      [{:sendwitharguments=>
                         {:@block=>nil,
                          :@name=>:puts,
                          :@line=>5,
                          :@privately=>true,
                          :@receiver=>{:self=>{:@line=>5}},
                          :@check_for_local=>false,
                          :@arguments=>
                           {:actualarguments=>
                             {:@array=>
                               [{:stringliteral=>
                                  {:@string=>:something, :@line=>5}}],
                              :@splat=>nil,
                              :@line=>5}}}},
                       {:localvariableassignment=>
                         {:@variable=>nil,
                          :@name=>:result,
                          :@line=>6,
                          :@value=>
                           {:stringliteral=>{:@string=>:red, :@line=>6}}}}],
                     :@line=>5}},
                 :@splat=>nil,
                 :@line=>13,
                 :@single=>{:fixnumliteral=>{:@line=>4, :@value=>1}}}},
              {:when=>
                {:@conditions=>
                  {:arrayliteral=>
                    {:@body=>
                      [{:fixnumliteral=>{:@line=>7, :@value=>2}},
                       {:fixnumliteral=>{:@line=>7, :@value=>3}}],
                     :@line=>7}},
                 :@body=>
                  {:localvariableassignment=>
                    {:@variable=>nil,
                     :@name=>:result,
                     :@line=>8,
                     :@value=>{:stringliteral=>{:@string=>:yellow, :@line=>8}}}},
                 :@splat=>nil,
                 :@line=>13,
                 :@single=>nil}},
              {:when=>
                {:@body=>{},
                 :@splat=>nil,
                 :@line=>13,
                 :@single=>{:fixnumliteral=>{:@line=>9, :@value=>4}}}}],
            :@else=>
             {:localvariableassignment=>
               {:@variable=>nil,
                :@name=>:result,
                :@line=>12,
                :@value=>{:stringliteral=>{:@string=>:green, :@line=>12}}}},
            :@line=>3,
            :@receiver=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:var, :@line=>3}}}},
         {:receivercase=>
           {:@whens=>
             [{:when=>
                {:@body=>
                  {:localvariableassignment=>
                    {:@variable=>nil,
                     :@name=>:var,
                     :@line=>16,
                     :@value=>{:fixnumliteral=>{:@line=>16, :@value=>1}}}},
                 :@splat=>nil,
                 :@line=>23,
                 :@single=>{:stringliteral=>{:@string=>:red, :@line=>15}}}},
              {:when=>
                {:@body=>
                  {:localvariableassignment=>
                    {:@variable=>nil,
                     :@name=>:var,
                     :@line=>18,
                     :@value=>{:fixnumliteral=>{:@line=>18, :@value=>2}}}},
                 :@splat=>nil,
                 :@line=>23,
                 :@single=>{:stringliteral=>{:@string=>:yellow, :@line=>17}}}},
              {:when=>
                {:@body=>
                  {:localvariableassignment=>
                    {:@variable=>nil,
                     :@name=>:var,
                     :@line=>20,
                     :@value=>{:fixnumliteral=>{:@line=>20, :@value=>3}}}},
                 :@splat=>nil,
                 :@line=>23,
                 :@single=>{:stringliteral=>{:@string=>:green, :@line=>19}}}}],
            :@else=>{},
            :@line=>14,
            :@receiver=>
             {:localvariableaccess=>
               {:@variable=>nil, :@name=>:result, :@line=>14}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "case ..."' do
    ruby = <<-ruby
        case a
        when b then
          case
          when (d and e) then
            f
          else
            # do nothing
          end
        else
          # do nothing
        end
      ruby
    ast  = {:receivercase=>
      {:@whens=>
        [{:when=>
           {:@body=>
             {:case=>
               {:@whens=>
                 [{:when=>
                    {:@body=>
                      {:send=>
                        {:@block=>nil,
                         :@name=>:f,
                         :@line=>5,
                         :@privately=>true,
                         :@receiver=>{:self=>{:@line=>5}},
                         :@check_for_local=>false}},
                     :@splat=>nil,
                     :@line=>8,
                     :@single=>
                      {:and=>
                        {:@line=>4,
                         :@left=>
                          {:send=>
                            {:@block=>nil,
                             :@name=>:d,
                             :@line=>4,
                             :@privately=>true,
                             :@receiver=>{:self=>{:@line=>4}},
                             :@check_for_local=>false}},
                         :@right=>
                          {:send=>
                            {:@block=>nil,
                             :@name=>:e,
                             :@line=>4,
                             :@privately=>true,
                             :@receiver=>{:self=>{:@line=>4}},
                             :@check_for_local=>false}}}}}}],
                :@else=>{},
                :@line=>11}},
            :@splat=>nil,
            :@line=>11,
            :@single=>
             {:send=>
               {:@block=>nil,
                :@name=>:b,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false}}}}],
       :@else=>{},
       :@line=>1,
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "case ..."' do
    ruby = <<-ruby
        var1 = 1
        var2 = 2
        result = nil
        case var1
        when 1 then
          case var2
          when 1 then
            result = 1
          when 2 then
            result = 2
          else
            result = 3
          end
        when 2 then
          case var2
          when 1 then
            result = 4
          when 2 then
            result = 5
          else
            result = 6
          end
        else
          result = 7
        end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:var1,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:var2,
            :@line=>2,
            :@value=>{:fixnumliteral=>{:@line=>2, :@value=>2}}}},
         {:localvariableassignment=>
           {:@variable=>nil, :@name=>:result, :@line=>3, :@value=>{}}},
         {:receivercase=>
           {:@whens=>
             [{:when=>
                {:@body=>
                  {:receivercase=>
                    {:@whens=>
                      [{:when=>
                         {:@body=>
                           {:localvariableassignment=>
                             {:@variable=>nil,
                              :@name=>:result,
                              :@line=>8,
                              :@value=>{:fixnumliteral=>{:@line=>8, :@value=>1}}}},
                          :@splat=>nil,
                          :@line=>13,
                          :@single=>{:fixnumliteral=>{:@line=>7, :@value=>1}}}},
                       {:when=>
                         {:@body=>
                           {:localvariableassignment=>
                             {:@variable=>nil,
                              :@name=>:result,
                              :@line=>10,
                              :@value=>
                               {:fixnumliteral=>{:@line=>10, :@value=>2}}}},
                          :@splat=>nil,
                          :@line=>13,
                          :@single=>{:fixnumliteral=>{:@line=>9, :@value=>2}}}}],
                     :@else=>
                      {:localvariableassignment=>
                        {:@variable=>nil,
                         :@name=>:result,
                         :@line=>12,
                         :@value=>{:fixnumliteral=>{:@line=>12, :@value=>3}}}},
                     :@line=>6,
                     :@receiver=>
                      {:localvariableaccess=>
                        {:@variable=>nil, :@name=>:var2, :@line=>6}}}},
                 :@splat=>nil,
                 :@line=>25,
                 :@single=>{:fixnumliteral=>{:@line=>5, :@value=>1}}}},
              {:when=>
                {:@body=>
                  {:receivercase=>
                    {:@whens=>
                      [{:when=>
                         {:@body=>
                           {:localvariableassignment=>
                             {:@variable=>nil,
                              :@name=>:result,
                              :@line=>17,
                              :@value=>
                               {:fixnumliteral=>{:@line=>17, :@value=>4}}}},
                          :@splat=>nil,
                          :@line=>22,
                          :@single=>{:fixnumliteral=>{:@line=>16, :@value=>1}}}},
                       {:when=>
                         {:@body=>
                           {:localvariableassignment=>
                             {:@variable=>nil,
                              :@name=>:result,
                              :@line=>19,
                              :@value=>
                               {:fixnumliteral=>{:@line=>19, :@value=>5}}}},
                          :@splat=>nil,
                          :@line=>22,
                          :@single=>{:fixnumliteral=>{:@line=>18, :@value=>2}}}}],
                     :@else=>
                      {:localvariableassignment=>
                        {:@variable=>nil,
                         :@name=>:result,
                         :@line=>21,
                         :@value=>{:fixnumliteral=>{:@line=>21, :@value=>6}}}},
                     :@line=>15,
                     :@receiver=>
                      {:localvariableaccess=>
                        {:@variable=>nil, :@name=>:var2, :@line=>15}}}},
                 :@splat=>nil,
                 :@line=>25,
                 :@single=>{:fixnumliteral=>{:@line=>14, :@value=>2}}}}],
            :@else=>
             {:localvariableassignment=>
               {:@variable=>nil,
                :@name=>:result,
                :@line=>24,
                :@value=>{:fixnumliteral=>{:@line=>24, :@value=>7}}}},
            :@line=>4,
            :@receiver=>
             {:localvariableaccess=>
               {:@variable=>nil, :@name=>:var1, :@line=>4}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "case ..."' do
    ruby = <<-ruby
        case
        when (a == 1) then
          :a
        when (a == 2) then
          :b
        else
          :c
        end
      ruby
    ast  = {:case=>
      {:@whens=>
        [{:when=>
           {:@body=>{:symbolliteral=>{:@line=>3, :@value=>:a}},
            :@splat=>nil,
            :@line=>8,
            :@single=>
             {:sendwitharguments=>
               {:@block=>nil,
                :@name=>:==,
                :@line=>2,
                :@privately=>false,
                :@receiver=>
                 {:send=>
                   {:@block=>nil,
                    :@name=>:a,
                    :@line=>2,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>2}},
                    :@check_for_local=>false}},
                :@check_for_local=>false,
                :@arguments=>
                 {:actualarguments=>
                   {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
                    :@splat=>nil,
                    :@line=>2}}}}}},
         {:when=>
           {:@body=>{:symbolliteral=>{:@line=>5, :@value=>:b}},
            :@splat=>nil,
            :@line=>8,
            :@single=>
             {:sendwitharguments=>
               {:@block=>nil,
                :@name=>:==,
                :@line=>4,
                :@privately=>false,
                :@receiver=>
                 {:send=>
                   {:@block=>nil,
                    :@name=>:a,
                    :@line=>4,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>4}},
                    :@check_for_local=>false}},
                :@check_for_local=>false,
                :@arguments=>
                 {:actualarguments=>
                   {:@array=>[{:fixnumliteral=>{:@line=>4, :@value=>2}}],
                    :@splat=>nil,
                    :@line=>4}}}}}}],
       :@else=>{:symbolliteral=>{:@line=>7, :@value=>:c}},
       :@line=>8}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "case ..."' do
    ruby = <<-ruby
        case a
        when :b, *c then
          d
        else
          e
        end
      ruby
    ast  = {:receivercase=>
      {:@whens=>
        [{:when=>
           {:@conditions=>
             {:arrayliteral=>
               {:@body=>[{:symbolliteral=>{:@line=>2, :@value=>:b}}], :@line=>2}},
            :@body=>
             {:send=>
               {:@block=>nil,
                :@name=>:d,
                :@line=>3,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>3}},
                :@check_for_local=>false}},
            :@splat=>
             {:splatwhen=>
               {:@condition=>
                 {:send=>
                   {:@block=>nil,
                    :@name=>:c,
                    :@line=>2,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>2}},
                    :@check_for_local=>false}},
                :@line=>6}},
            :@line=>6,
            :@single=>nil}}],
       :@else=>
        {:send=>
          {:@block=>nil,
           :@name=>:e,
           :@line=>5,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>5}},
           :@check_for_local=>false}},
       :@line=>1,
       :@receiver=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "case true ..."' do
    ruby = <<-ruby
        case true
        when String, *%w(foo bar baz) then
          12
        end
      ruby
    ast  = {:receivercase=>
      {:@whens=>
        [{:when=>
           {:@conditions=>
             {:arrayliteral=>
               {:@body=>
                 [{:constfind=>{:@name=>:String, :@line=>2}},
                  {:stringliteral=>{:@string=>:foo, :@line=>2}},
                  {:stringliteral=>{:@string=>:bar, :@line=>2}},
                  {:stringliteral=>{:@string=>:baz, :@line=>2}}],
                :@line=>2}},
            :@body=>{:fixnumliteral=>{:@line=>3, :@value=>12}},
            :@splat=>nil,
            :@line=>4,
            :@single=>nil}}],
       :@else=>{},
       :@line=>1,
       :@receiver=>{:true=>{:@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "case() ..."' do
    ruby = <<-ruby
        case ()
        when a
          1
        end
      ruby
    ast  = {:receivercase=>
      {:@whens=>
        [{:when=>
           {:@body=>{:fixnumliteral=>{:@line=>3, :@value=>1}},
            :@splat=>nil,
            :@line=>4,
            :@single=>
             {:send=>
               {:@block=>nil,
                :@name=>:a,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false}}}}],
       :@else=>{},
       :@line=>1,
       :@receiver=>{}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "case ..."' do
    ruby = <<-ruby
        x = 1
        case a
        when x
          2
        end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:x,
            :@line=>1,
            :@value=>{:fixnumliteral=>{:@line=>1, :@value=>1}}}},
         {:receivercase=>
           {:@whens=>
             [{:when=>
                {:@body=>{:fixnumliteral=>{:@line=>4, :@value=>2}},
                 :@splat=>nil,
                 :@line=>5,
                 :@single=>
                  {:localvariableaccess=>
                    {:@variable=>nil, :@name=>:x, :@line=>3}}}}],
            :@else=>{},
            :@line=>2,
            :@receiver=>
             {:send=>
               {:@block=>nil,
                :@name=>:a,
                :@line=>2,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>2}},
                :@check_for_local=>false}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
