require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "while a ..."' do
    ruby = <<-ruby
        while a
          b + 1
        end
      ruby
    ast  = {:while=>
      {:@body=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:+,
           :@line=>2,
           :@privately=>false,
           :@receiver=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>2,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>2}},
               :@check_for_local=>false}},
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
               :@splat=>nil,
               :@line=>2}}}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a = x; while a.b ..."' do
    ruby = <<-ruby
        a = x
        while a.b
          1
        end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:a,
            :@line=>1,
            :@value=>
             {:send=>
               {:@block=>nil,
                :@name=>:x,
                :@line=>1,
                :@privately=>true,
                :@receiver=>{:self=>{:@line=>1}},
                :@check_for_local=>false}}}},
         {:while=>
           {:@body=>{:fixnumliteral=>{:@line=>3, :@value=>1}},
            :@condition=>
             {:send=>
               {:@block=>nil,
                :@name=>:b,
                :@line=>2,
                :@privately=>false,
                :@receiver=>
                 {:localvariableaccess=>{:@variable=>nil, :@name=>:a, :@line=>2}},
                :@check_for_local=>false}},
            :@line=>2,
            :@check_first=>true}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "b + 1 while a"' do
    ruby = 'b + 1 while a'
    ast  = {:while=>
      {:@body=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:+,
           :@line=>1,
           :@privately=>false,
           :@receiver=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
               :@splat=>nil,
               :@line=>1}}}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "until not a ..."' do
    ruby = <<-ruby
        until not a
          b + 1
        end
      ruby
    ast  = {:while=>
      {:@body=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:+,
           :@line=>2,
           :@privately=>false,
           :@receiver=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>2,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>2}},
               :@check_for_local=>false}},
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
               :@splat=>nil,
               :@line=>2}}}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "b + 1 until not a"' do
    ruby = 'b + 1 until not a'
    ast  = {:while=>
      {:@body=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:+,
           :@line=>1,
           :@privately=>false,
           :@receiver=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>1,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>1}},
               :@check_for_local=>false}},
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>1}}],
               :@splat=>nil,
               :@line=>1}}}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... end while a"' do
    ruby = <<-ruby
        begin
          b + 1
        end while a
      ruby
    ast  = {:while=>
      {:@body=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:+,
           :@line=>2,
           :@privately=>false,
           :@receiver=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>2,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>2}},
               :@check_for_local=>false}},
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
               :@splat=>nil,
               :@line=>2}}}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>3,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>3}},
           :@check_for_local=>false}},
       :@line=>3,
       :@check_first=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... end until not a"' do
    ruby = <<-ruby
        begin
          b + 1
        end until not a
      ruby
    ast  = {:while=>
      {:@body=>
        {:sendwitharguments=>
          {:@block=>nil,
           :@name=>:+,
           :@line=>2,
           :@privately=>false,
           :@receiver=>
            {:send=>
              {:@block=>nil,
               :@name=>:b,
               :@line=>2,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>2}},
               :@check_for_local=>false}},
           :@check_for_local=>false,
           :@arguments=>
            {:actualarguments=>
              {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
               :@splat=>nil,
               :@line=>2}}}},
       :@condition=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>3,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>3}},
           :@check_for_local=>false}},
       :@line=>3,
       :@check_first=>false}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "while () ..."' do
    ruby = <<-ruby
        while ()
          a
        end
      ruby
    ast  = {:while=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>2,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>2}},
           :@check_for_local=>false}},
       :@condition=>{},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "until not () ..."' do
    ruby = <<-ruby
        until not ()
          a
        end
      ruby
    ast  = {:while=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>2,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>2}},
           :@check_for_local=>false}},
       :@condition=>{},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "a until not ()"' do
    ruby = 'a until not ()'
    ast  = {:while=>
      {:@body=>
        {:send=>
          {:@block=>nil,
           :@name=>:a,
           :@line=>1,
           :@privately=>true,
           :@receiver=>{:self=>{:@line=>1}},
           :@check_for_local=>false}},
       :@condition=>{},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "while 1 ... break ..."' do
    ruby = <<-ruby
        while 1
          2
          break :brk
        end
      ruby
    ast  = {:while=>
      {:@body=>
        {:block=>
          {:@array=>
            [{:fixnumliteral=>{:@line=>2, :@value=>2}},
             {:break=>
               {:@line=>3,
                :@value=>{:symbolliteral=>{:@line=>3, :@value=>:brk}}}}],
           :@line=>2}},
       :@condition=>{:fixnumliteral=>{:@line=>1, :@value=>1}},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "while 1 ... begin ... break ... rescue ..."' do
    ruby = <<-ruby
        while 1
          begin
            2
            break :brk
          rescue
            3
          end
        end
      ruby
    ast  = {:while=>
      {:@body=>
        {:begin=>
          {:@rescue=>
            {:rescue=>
              {:@body=>
                {:block=>
                  {:@array=>
                    [{:fixnumliteral=>{:@line=>3, :@value=>2}},
                     {:break=>
                       {:@line=>4,
                        :@value=>{:symbolliteral=>{:@line=>4, :@value=>:brk}}}}],
                   :@line=>3}},
               :@rescue=>
                {:rescuecondition=>
                  {:@conditions=>
                    {:arrayliteral=>
                      {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>6}}],
                       :@line=>6}},
                   :@body=>{:fixnumliteral=>{:@line=>6, :@value=>3}},
                   :@splat=>nil,
                   :@next=>nil,
                   :@line=>6,
                   :@assignment=>nil}},
               :@else=>nil,
               :@line=>3}},
           :@line=>2}},
       :@condition=>{:fixnumliteral=>{:@line=>1, :@value=>1}},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "while 1 ... begin ... rescue ... break"' do
    ruby = <<-ruby
        while 1
          begin
            2
          rescue
            3
            break :brk
          end
        end
      ruby
    ast  = {:while=>
      {:@body=>
        {:begin=>
          {:@rescue=>
            {:rescue=>
              {:@body=>{:fixnumliteral=>{:@line=>3, :@value=>2}},
               :@rescue=>
                {:rescuecondition=>
                  {:@conditions=>
                    {:arrayliteral=>
                      {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>5}}],
                       :@line=>5}},
                   :@body=>
                    {:block=>
                      {:@array=>
                        [{:fixnumliteral=>{:@line=>5, :@value=>3}},
                         {:break=>
                           {:@line=>6,
                            :@value=>
                             {:symbolliteral=>{:@line=>6, :@value=>:brk}}}}],
                       :@line=>5}},
                   :@splat=>nil,
                   :@next=>nil,
                   :@line=>5,
                   :@assignment=>nil}},
               :@else=>nil,
               :@line=>3}},
           :@line=>2}},
       :@condition=>{:fixnumliteral=>{:@line=>1, :@value=>1}},
       :@line=>1,
       :@check_first=>true}}

    ruby.should parse_as(ast)
  end

end
