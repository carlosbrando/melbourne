require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "blah rescue nil"' do
    ruby = 'blah rescue nil'
    ast  = {:rescue=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:blah,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@rescue=>
        {:rescuecondition=>
          {:@conditions=>
            {:arrayliteral=>
              {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>1}}],
               :@line=>1}},
           :@body=>{},
           :@splat=>nil,
           :@next=>nil,
           :@line=>1,
           :@assignment=>nil}},
       :@else=>nil,
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... blah ... rescue ..."' do
    ruby = <<-ruby
        begin
          blah
        rescue
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:blah,
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
               :@body=>{},
               :@splat=>nil,
               :@next=>nil,
               :@line=>4,
               :@assignment=>nil}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue A ... rescue B ..."' do
    ruby = <<-ruby
        begin
          a
        rescue A
          b
        rescue B
          c
        rescue C
          d
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:a,
               :@line=>2,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>2}},
               :@check_for_local=>false}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:A, :@line=>3}}], :@line=>3}},
               :@body=>
                {:send=>
                  {:@block=>nil,
                   :@name=>:b,
                   :@line=>4,
                   :@privately=>true,
                   :@receiver=>{:self=>{:@line=>4}},
                   :@check_for_local=>false}},
               :@splat=>nil,
               :@next=>
                {:rescuecondition=>
                  {:@conditions=>
                    {:arrayliteral=>
                      {:@body=>[{:constfind=>{:@name=>:B, :@line=>5}}],
                       :@line=>5}},
                   :@body=>
                    {:send=>
                      {:@block=>nil,
                       :@name=>:c,
                       :@line=>6,
                       :@privately=>true,
                       :@receiver=>{:self=>{:@line=>6}},
                       :@check_for_local=>false}},
                   :@splat=>nil,
                   :@next=>
                    {:rescuecondition=>
                      {:@conditions=>
                        {:arrayliteral=>
                          {:@body=>[{:constfind=>{:@name=>:C, :@line=>7}}],
                           :@line=>7}},
                       :@body=>
                        {:send=>
                          {:@block=>nil,
                           :@name=>:d,
                           :@line=>8,
                           :@privately=>true,
                           :@receiver=>{:self=>{:@line=>8}},
                           :@check_for_local=>false}},
                       :@splat=>nil,
                       :@next=>nil,
                       :@line=>7,
                       :@assignment=>nil}},
                   :@line=>5,
                   :@assignment=>nil}},
               :@line=>3,
               :@assignment=>nil}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue => @e ..."' do
    ruby = <<-ruby
        begin
          a
        rescue => @e
          c
          d
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:a,
               :@line=>2,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>2}},
               :@check_for_local=>false}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>3}}],
                   :@line=>3}},
               :@body=>
                {:block=>
                  {:@array=>
                    [{:send=>
                       {:@block=>nil,
                        :@name=>:c,
                        :@line=>4,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>4}},
                        :@check_for_local=>false}},
                     {:send=>
                       {:@block=>nil,
                        :@name=>:d,
                        :@line=>5,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>5}},
                        :@check_for_local=>false}}],
                   :@line=>3}},
               :@splat=>nil,
               :@next=>nil,
               :@line=>3,
               :@assignment=>
                {:instancevariableassignment=>
                  {:@name=>:@e,
                   :@line=>3,
                   :@value=>{:globalvariableaccess=>{:@name=>:$!, :@line=>6}}}}}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue => e ..."' do
    ruby = <<-ruby
        begin
          a
        rescue => e
          c
          d
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:a,
               :@line=>2,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>2}},
               :@check_for_local=>false}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>3}}],
                   :@line=>3}},
               :@body=>
                {:block=>
                  {:@array=>
                    [{:send=>
                       {:@block=>nil,
                        :@name=>:c,
                        :@line=>4,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>4}},
                        :@check_for_local=>false}},
                     {:send=>
                       {:@block=>nil,
                        :@name=>:d,
                        :@line=>5,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>5}},
                        :@check_for_local=>false}}],
                   :@line=>3}},
               :@splat=>nil,
               :@next=>nil,
               :@line=>3,
               :@assignment=>
                {:localvariableassignment=>
                  {:@variable=>nil,
                   :@name=>:e,
                   :@line=>3,
                   :@value=>{:globalvariableaccess=>{:@name=>:$!, :@line=>6}}}}}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue => mes ... begin ... rescue => mes ..."' do
    ruby = <<-ruby
        begin
          a
        rescue => mes
          # do nothing
        end

        begin
          b
        rescue => mes
          # do nothing
        end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:begin=>
           {:@rescue=>
             {:rescue=>
               {:@body=>
                 {:send=>
                   {:@block=>nil,
                    :@name=>:a,
                    :@line=>2,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>2}},
                    :@check_for_local=>false}},
                :@rescue=>
                 {:rescuecondition=>
                   {:@conditions=>
                     {:arrayliteral=>
                       {:@body=>
                         [{:constfind=>{:@name=>:StandardError, :@line=>3}}],
                        :@line=>3}},
                    :@body=>{},
                    :@splat=>nil,
                    :@next=>nil,
                    :@line=>3,
                    :@assignment=>
                     {:localvariableassignment=>
                       {:@variable=>nil,
                        :@name=>:mes,
                        :@line=>3,
                        :@value=>
                         {:globalvariableaccess=>{:@name=>:$!, :@line=>5}}}}}},
                :@else=>nil,
                :@line=>2}},
            :@line=>1}},
         {:begin=>
           {:@rescue=>
             {:rescue=>
               {:@body=>
                 {:send=>
                   {:@block=>nil,
                    :@name=>:b,
                    :@line=>8,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>8}},
                    :@check_for_local=>false}},
                :@rescue=>
                 {:rescuecondition=>
                   {:@conditions=>
                     {:arrayliteral=>
                       {:@body=>
                         [{:constfind=>{:@name=>:StandardError, :@line=>9}}],
                        :@line=>9}},
                    :@body=>{},
                    :@splat=>nil,
                    :@next=>nil,
                    :@line=>9,
                    :@assignment=>
                     {:localvariableassignment=>
                       {:@variable=>nil,
                        :@name=>:mes,
                        :@line=>9,
                        :@value=>
                         {:globalvariableaccess=>{:@name=>:$!, :@line=>11}}}}}},
                :@else=>nil,
                :@line=>8}},
            :@line=>7}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... blah ... rescue RuntimeError => r ..."' do
    ruby = <<-ruby
        begin
          blah
        rescue RuntimeError => r
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:blah,
               :@line=>2,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>2}},
               :@check_for_local=>false}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:RuntimeError, :@line=>3}}],
                   :@line=>3}},
               :@body=>{},
               :@splat=>nil,
               :@next=>nil,
               :@line=>3,
               :@assignment=>
                {:localvariableassignment=>
                  {:@variable=>nil,
                   :@name=>:r,
                   :@line=>3,
                   :@value=>{:globalvariableaccess=>{:@name=>:$!, :@line=>4}}}}}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... 1 ... rescue => @e"' do
    ruby = <<-ruby
        begin
          1
        rescue => @e
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>1}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>3}}],
                   :@line=>3}},
               :@body=>{},
               :@splat=>nil,
               :@next=>nil,
               :@line=>3,
               :@assignment=>
                {:instancevariableassignment=>
                  {:@name=>:@e,
                   :@line=>3,
                   :@value=>{:globalvariableaccess=>{:@name=>:$!, :@line=>4}}}}}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue ... var = 2 ..."' do
    ruby = <<-ruby
        begin
          1
        rescue
          var = 2
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>1}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>4}}],
                   :@line=>4}},
               :@body=>
                {:localvariableassignment=>
                  {:@variable=>nil,
                   :@name=>:var,
                   :@line=>4,
                   :@value=>{:fixnumliteral=>{:@line=>4, :@value=>2}}}},
               :@splat=>nil,
               :@next=>nil,
               :@line=>4,
               :@assignment=>nil}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin 1 rescue => e ..."' do
    ruby = <<-ruby
        begin
          1
        rescue => e
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>1}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>3}}],
                   :@line=>3}},
               :@body=>{},
               :@splat=>nil,
               :@next=>nil,
               :@line=>3,
               :@assignment=>
                {:localvariableassignment=>
                  {:@variable=>nil,
                   :@name=>:e,
                   :@line=>3,
                   :@value=>{:globalvariableaccess=>{:@name=>:$!, :@line=>4}}}}}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin 1 rescue a.b = nil ..."' do
    ruby = <<-ruby
        begin
          1
        rescue
          a.b = nil
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>1}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>4}}],
                   :@line=>4}},
               :@body=>
                {:attributeassignment=>
                  {:@name=>:b=,
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
                   :@arguments=>
                    {:actualarguments=>{:@array=>[{}], :@splat=>nil, :@line=>4}}}},
               :@splat=>nil,
               :@next=>nil,
               :@line=>4,
               :@assignment=>nil}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin 1 rescue => e var = 2 ..."' do
    ruby = <<-ruby
        begin
          1
        rescue => e
          var = 2
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>1}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>3}}],
                   :@line=>3}},
               :@body=>
                {:block=>
                  {:@array=>
                    [{:localvariableassignment=>
                       {:@variable=>nil,
                        :@name=>:var,
                        :@line=>4,
                        :@value=>{:fixnumliteral=>{:@line=>4, :@value=>2}}}}],
                   :@line=>3}},
               :@splat=>nil,
               :@next=>nil,
               :@line=>3,
               :@assignment=>
                {:localvariableassignment=>
                  {:@variable=>nil,
                   :@name=>:e,
                   :@line=>3,
                   :@value=>{:globalvariableaccess=>{:@name=>:$!, :@line=>5}}}}}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue ... else ..."' do
    ruby = <<-ruby
        begin
          12
        rescue String
          13
        else
          14
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>12}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:String, :@line=>3}}],
                   :@line=>3}},
               :@body=>{:fixnumliteral=>{:@line=>4, :@value=>13}},
               :@splat=>nil,
               :@next=>nil,
               :@line=>3,
               :@assignment=>nil}},
           :@else=>{:fixnumliteral=>{:@line=>6, :@value=>14}},
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue *blah ..."' do
    ruby = <<-ruby
        begin
          12
        rescue *blah
          13
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>12}},
           :@rescue=>
            {:rescuecondition=>
              {:@body=>{:fixnumliteral=>{:@line=>4, :@value=>13}},
               :@splat=>
                {:rescuesplat=>
                  {:@line=>3,
                   :@value=>
                    {:send=>
                      {:@block=>nil,
                       :@name=>:blah,
                       :@line=>3,
                       :@privately=>true,
                       :@receiver=>{:self=>{:@line=>3}},
                       :@check_for_local=>false}}}},
               :@next=>nil,
               :@line=>3,
               :@assignment=>nil}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue String, *blah ..."' do
    ruby = <<-ruby
        begin
          12
        rescue String, *blah
          13
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>12}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:String, :@line=>3}}],
                   :@line=>3}},
               :@body=>{:fixnumliteral=>{:@line=>4, :@value=>13}},
               :@splat=>
                {:rescuesplat=>
                  {:@line=>3,
                   :@value=>
                    {:send=>
                      {:@block=>nil,
                       :@name=>:blah,
                       :@line=>3,
                       :@privately=>true,
                       :@receiver=>{:self=>{:@line=>3}},
                       :@check_for_local=>false}}}},
               :@next=>nil,
               :@line=>3,
               :@assignment=>nil}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue *blah => e ..."' do
    ruby = <<-ruby
        begin
          12
        rescue *blah => e
          13
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>12}},
           :@rescue=>
            {:rescuecondition=>
              {:@body=>
                {:block=>
                  {:@array=>[{:fixnumliteral=>{:@line=>4, :@value=>13}}],
                   :@line=>3}},
               :@splat=>
                {:rescuesplat=>
                  {:@line=>3,
                   :@value=>
                    {:send=>
                      {:@block=>nil,
                       :@name=>:blah,
                       :@line=>3,
                       :@privately=>true,
                       :@receiver=>{:self=>{:@line=>3}},
                       :@check_for_local=>false}}}},
               :@next=>nil,
               :@line=>3,
               :@assignment=>
                {:localvariableassignment=>
                  {:@variable=>nil,
                   :@name=>:e,
                   :@line=>3,
                   :@value=>{:globalvariableaccess=>{:@name=>:$!, :@line=>5}}}}}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue String, *blah => e ..."' do
    ruby = <<-ruby
        begin
          12
        rescue String, *blah => e
          13
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>12}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:String, :@line=>3}}],
                   :@line=>3}},
               :@body=>
                {:block=>
                  {:@array=>[{:fixnumliteral=>{:@line=>4, :@value=>13}}],
                   :@line=>3}},
               :@splat=>
                {:rescuesplat=>
                  {:@line=>3,
                   :@value=>
                    {:send=>
                      {:@block=>nil,
                       :@name=>:blah,
                       :@line=>3,
                       :@privately=>true,
                       :@receiver=>{:self=>{:@line=>3}},
                       :@check_for_local=>false}}}},
               :@next=>nil,
               :@line=>3,
               :@assignment=>
                {:localvariableassignment=>
                  {:@variable=>nil,
                   :@name=>:e,
                   :@line=>3,
                   :@value=>{:globalvariableaccess=>{:@name=>:$!, :@line=>5}}}}}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue ... return"' do
    ruby = <<-ruby
        begin
          12
        rescue String
          return nil
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>12}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:String, :@line=>3}}],
                   :@line=>3}},
               :@body=>{:return=>{:@splat=>nil, :@line=>4, :@value=>{}}},
               :@splat=>nil,
               :@next=>nil,
               :@line=>3,
               :@assignment=>nil}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue begin ... rescue ..."' do
    ruby = <<-ruby
        begin
          1
        rescue
          begin
            2
          rescue
            return 3
          end
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>1}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>4}}],
                   :@line=>4}},
               :@body=>
                {:begin=>
                  {:@rescue=>
                    {:rescue=>
                      {:@body=>{:fixnumliteral=>{:@line=>5, :@value=>2}},
                       :@rescue=>
                        {:rescuecondition=>
                          {:@conditions=>
                            {:arrayliteral=>
                              {:@body=>
                                [{:constfind=>
                                   {:@name=>:StandardError, :@line=>7}}],
                               :@line=>7}},
                           :@body=>
                            {:return=>
                              {:@splat=>nil,
                               :@line=>7,
                               :@value=>
                                {:fixnumliteral=>{:@line=>7, :@value=>3}}}},
                           :@splat=>nil,
                           :@next=>nil,
                           :@line=>7,
                           :@assignment=>nil}},
                       :@else=>nil,
                       :@line=>5}},
                   :@line=>4}},
               :@splat=>nil,
               :@next=>nil,
               :@line=>4,
               :@assignment=>nil}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue def ..."' do
    ruby = <<-ruby
        begin
          1
        rescue
          def x
            return 2
          end
          x
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>1}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>4}}],
                   :@line=>4}},
               :@body=>
                {:block=>
                  {:@array=>
                    [{:define=>
                       {:@body=>
                         {:block=>
                           {:@array=>
                             [{:return=>
                                {:@splat=>nil,
                                 :@line=>5,
                                 :@value=>
                                  {:fixnumliteral=>{:@line=>5, :@value=>2}}}}],
                            :@line=>4}},
                        :@name=>:x,
                        :@line=>4,
                        :@arguments=>
                         {:formalarguments=>
                           {:@block_arg=>nil,
                            :@names=>[],
                            :@defaults=>nil,
                            :@optional=>[],
                            :@splat=>nil,
                            :@line=>4,
                            :@required=>[]}}}},
                     {:send=>
                       {:@block=>nil,
                        :@name=>:x,
                        :@line=>7,
                        :@privately=>true,
                        :@receiver=>{:self=>{:@line=>7}},
                        :@check_for_local=>false}}],
                   :@line=>4}},
               :@splat=>nil,
               :@next=>nil,
               :@line=>4,
               :@assignment=>nil}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin while ... break ... rescue ..."' do
    ruby = <<-ruby
        begin
          while 1
            2
            break :brk
          end
        rescue
          3
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>
            {:while=>
              {:@body=>
                {:block=>
                  {:@array=>
                    [{:fixnumliteral=>{:@line=>3, :@value=>2}},
                     {:break=>
                       {:@line=>4,
                        :@value=>{:symbolliteral=>{:@line=>4, :@value=>:brk}}}}],
                   :@line=>3}},
               :@condition=>{:fixnumliteral=>{:@line=>2, :@value=>1}},
               :@line=>2,
               :@check_first=>true}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>7}}],
                   :@line=>7}},
               :@body=>{:fixnumliteral=>{:@line=>7, :@value=>3}},
               :@splat=>nil,
               :@next=>nil,
               :@line=>7,
               :@assignment=>nil}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue while ... break ..."' do
    ruby = <<-ruby
        begin
          1
        rescue
          while 2
            3
            break :brk
          end
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:rescue=>
          {:@body=>{:fixnumliteral=>{:@line=>2, :@value=>1}},
           :@rescue=>
            {:rescuecondition=>
              {:@conditions=>
                {:arrayliteral=>
                  {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>4}}],
                   :@line=>4}},
               :@body=>
                {:while=>
                  {:@body=>
                    {:block=>
                      {:@array=>
                        [{:fixnumliteral=>{:@line=>5, :@value=>3}},
                         {:break=>
                           {:@line=>6,
                            :@value=>
                             {:symbolliteral=>{:@line=>6, :@value=>:brk}}}}],
                       :@line=>5}},
                   :@condition=>{:fixnumliteral=>{:@line=>4, :@value=>2}},
                   :@line=>4,
                   :@check_first=>true}},
               :@splat=>nil,
               :@next=>nil,
               :@line=>4,
               :@assignment=>nil}},
           :@else=>nil,
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
