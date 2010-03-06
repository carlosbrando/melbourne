require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "begin ... rescue ... ensure ..."' do
    ruby = <<-ruby
        begin
          # do nothing
        rescue
          # do nothing
        ensure
          # do nothing
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:ensure=>
          {:@ensure=>{},
           :@body=>
            {:rescue=>
              {:@body=>nil,
               :@rescue=>
                {:rescuecondition=>
                  {:@conditions=>
                    {:arrayliteral=>
                      {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>5}}],
                       :@line=>5}},
                   :@body=>{},
                   :@splat=>nil,
                   :@next=>nil,
                   :@line=>5,
                   :@assignment=>nil}},
               :@else=>nil,
               :@line=>7}},
           :@line=>7}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... rescue SyntaxError ... rescue Exception ..."' do
    ruby = <<-ruby
        begin
          (1 + 1)
        rescue SyntaxError => e1
          2
        rescue Exception => e2
          3
        else
          4
        ensure
          5
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:ensure=>
          {:@ensure=>{:fixnumliteral=>{:@line=>10, :@value=>5}},
           :@body=>
            {:rescue=>
              {:@body=>
                {:sendwitharguments=>
                  {:@block=>nil,
                   :@name=>:+,
                   :@line=>2,
                   :@privately=>false,
                   :@receiver=>{:fixnumliteral=>{:@line=>2, :@value=>1}},
                   :@check_for_local=>false,
                   :@arguments=>
                    {:actualarguments=>
                      {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>1}}],
                       :@splat=>nil,
                       :@line=>2}}}},
               :@rescue=>
                {:rescuecondition=>
                  {:@conditions=>
                    {:arrayliteral=>
                      {:@body=>[{:constfind=>{:@name=>:SyntaxError, :@line=>3}}],
                       :@line=>3}},
                   :@body=>
                    {:block=>
                      {:@array=>[{:fixnumliteral=>{:@line=>4, :@value=>2}}],
                       :@line=>3}},
                   :@splat=>nil,
                   :@next=>
                    {:rescuecondition=>
                      {:@conditions=>
                        {:arrayliteral=>
                          {:@body=>[{:constfind=>{:@name=>:Exception, :@line=>5}}],
                           :@line=>5}},
                       :@body=>
                        {:block=>
                          {:@array=>[{:fixnumliteral=>{:@line=>6, :@value=>3}}],
                           :@line=>5}},
                       :@splat=>nil,
                       :@next=>nil,
                       :@line=>5,
                       :@assignment=>
                        {:localvariableassignment=>
                          {:@variable=>nil,
                           :@name=>:e2,
                           :@line=>5,
                           :@value=>
                            {:globalvariableaccess=>{:@name=>:$!, :@line=>7}}}}}},
                   :@line=>3,
                   :@assignment=>
                    {:localvariableassignment=>
                      {:@variable=>nil,
                       :@name=>:e1,
                       :@line=>3,
                       :@value=>
                        {:globalvariableaccess=>{:@name=>:$!, :@line=>7}}}}}},
               :@else=>{:fixnumliteral=>{:@line=>8, :@value=>4}},
               :@line=>11}},
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... a ... rescue ... ensure ..."' do
    ruby = <<-ruby
        begin
          a
        rescue
          # do nothing
        ensure
          # do nothing
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:ensure=>
          {:@ensure=>{},
           :@body=>
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
                      {:@body=>[{:constfind=>{:@name=>:StandardError, :@line=>5}}],
                       :@line=>5}},
                   :@body=>{},
                   :@splat=>nil,
                   :@next=>nil,
                   :@line=>5,
                   :@assignment=>nil}},
               :@else=>nil,
               :@line=>7}},
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... return ... ensure"' do
    ruby = <<-ruby
        begin
          14
          return 2
        ensure
          13
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:ensure=>
          {:@ensure=>{:fixnumliteral=>{:@line=>5, :@value=>13}},
           :@body=>
            {:block=>
              {:@array=>
                [{:fixnumliteral=>{:@line=>2, :@value=>14}},
                 {:return=>
                   {:@splat=>nil,
                    :@line=>3,
                    :@value=>{:fixnumliteral=>{:@line=>3, :@value=>2}}}}],
               :@line=>2}},
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "begin ... begin ... ensure ... ensure"' do
    ruby = <<-ruby
        begin
          begin
            14
            return 2
          ensure
            13
          end
        ensure
          15
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:ensure=>
          {:@ensure=>{:fixnumliteral=>{:@line=>9, :@value=>15}},
           :@body=>
            {:begin=>
              {:@rescue=>
                {:ensure=>
                  {:@ensure=>{:fixnumliteral=>{:@line=>6, :@value=>13}},
                   :@body=>
                    {:block=>
                      {:@array=>
                        [{:fixnumliteral=>{:@line=>3, :@value=>14}},
                         {:return=>
                           {:@splat=>nil,
                            :@line=>4,
                            :@value=>{:fixnumliteral=>{:@line=>4, :@value=>2}}}}],
                       :@line=>3}},
                   :@line=>3}},
               :@line=>2}},
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse " begin ... return ... ensure ... begin ... return ... ensure"' do
    ruby = <<-ruby
        begin
          14
          return 2
        ensure
          begin
            15
            return 3
          ensure
            16
          end
        end
      ruby
    ast  = {:begin=>
      {:@rescue=>
        {:ensure=>
          {:@ensure=>
            {:begin=>
              {:@rescue=>
                {:ensure=>
                  {:@ensure=>{:fixnumliteral=>{:@line=>9, :@value=>16}},
                   :@body=>
                    {:block=>
                      {:@array=>
                        [{:fixnumliteral=>{:@line=>6, :@value=>15}},
                         {:return=>
                           {:@splat=>nil,
                            :@line=>7,
                            :@value=>{:fixnumliteral=>{:@line=>7, :@value=>3}}}}],
                       :@line=>6}},
                   :@line=>6}},
               :@line=>5}},
           :@body=>
            {:block=>
              {:@array=>
                [{:fixnumliteral=>{:@line=>2, :@value=>14}},
                 {:return=>
                   {:@splat=>nil,
                    :@line=>3,
                    :@value=>{:fixnumliteral=>{:@line=>3, :@value=>2}}}}],
               :@line=>2}},
           :@line=>2}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
