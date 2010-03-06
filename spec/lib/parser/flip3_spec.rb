require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "... ((i % 4) == 0)...((i % 3) == 0) ..."' do
    ruby = <<-ruby
        x = if ((i % 4) == 0)...((i % 3) == 0) then
          i
        else
          nil
        end
      ruby
    ast  = {:localvariableassignment=>
      {:@variable=>nil,
       :@name=>:x,
       :@line=>1,
       :@value=>
        {:if=>
          {:@body=>
            {:send=>
              {:@block=>nil,
               :@name=>:i,
               :@line=>2,
               :@privately=>true,
               :@receiver=>{:self=>{:@line=>2}},
               :@check_for_local=>false}},
           :@condition=>
            {:flip3=>
              {:@start=>
                {:sendwitharguments=>
                  {:@block=>nil,
                   :@name=>:==,
                   :@line=>1,
                   :@privately=>false,
                   :@receiver=>
                    {:sendwitharguments=>
                      {:@block=>nil,
                       :@name=>:%,
                       :@line=>1,
                       :@privately=>false,
                       :@receiver=>
                        {:send=>
                          {:@block=>nil,
                           :@name=>:i,
                           :@line=>1,
                           :@privately=>true,
                           :@receiver=>{:self=>{:@line=>1}},
                           :@check_for_local=>false}},
                       :@check_for_local=>false,
                       :@arguments=>
                        {:actualarguments=>
                          {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>4}}],
                           :@splat=>nil,
                           :@line=>1}}}},
                   :@check_for_local=>false,
                   :@arguments=>
                    {:actualarguments=>
                      {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>0}}],
                       :@splat=>nil,
                       :@line=>1}}}},
               :@finish=>
                {:sendwitharguments=>
                  {:@block=>nil,
                   :@name=>:==,
                   :@line=>1,
                   :@privately=>false,
                   :@receiver=>
                    {:sendwitharguments=>
                      {:@block=>nil,
                       :@name=>:%,
                       :@line=>1,
                       :@privately=>false,
                       :@receiver=>
                        {:send=>
                          {:@block=>nil,
                           :@name=>:i,
                           :@line=>1,
                           :@privately=>true,
                           :@receiver=>{:self=>{:@line=>1}},
                           :@check_for_local=>false}},
                       :@check_for_local=>false,
                       :@arguments=>
                        {:actualarguments=>
                          {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>3}}],
                           :@splat=>nil,
                           :@line=>1}}}},
                   :@check_for_local=>false,
                   :@arguments=>
                    {:actualarguments=>
                      {:@array=>[{:fixnumliteral=>{:@line=>1, :@value=>0}}],
                       :@splat=>nil,
                       :@line=>1}}}},
               :@line=>1}},
           :@else=>{},
           :@line=>1}}}}

    ruby.should parse_as(ast)
  end

end
