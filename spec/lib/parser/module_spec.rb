require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "module X; def y; end; end"' do
    ruby = <<-ruby
        module X
          def y
          end
        end
      ruby
    ast  = {:module=>
      {:@body=>
        {:modulescope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:define=>
                   {:@body=>{:block=>{:@array=>[{}], :@line=>2}},
                    :@name=>:y,
                    :@line=>2,
                    :@arguments=>
                     {:formalarguments=>
                       {:@block_arg=>nil,
                        :@names=>[],
                        :@defaults=>nil,
                        :@optional=>[],
                        :@splat=>nil,
                        :@line=>2,
                        :@required=>[]}}}}],
               :@line=>4}},
           :@name=>:X,
           :@line=>1}},
       :@name=>{:modulename=>{:@name=>:X, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "module ::Y; c; end"' do
    ruby = <<-ruby
        module ::Y
          c
        end
      ruby
    ast  = {:module=>
      {:@body=>
        {:modulescope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:send=>
                   {:@block=>nil,
                    :@name=>:c,
                    :@line=>2,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>2}},
                    :@check_for_local=>false}}],
               :@line=>3}},
           :@name=>:Y,
           :@line=>1}},
       :@name=>
        {:scopedmodulename=>
          {:@parent=>{:toplevel=>{:@line=>1}}, :@name=>:Y, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "modue X::Y; c; end"' do
    ruby = <<-ruby
        module X::Y
          c
        end
      ruby
    ast  = {:module=>
      {:@body=>
        {:modulescope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:send=>
                   {:@block=>nil,
                    :@name=>:c,
                    :@line=>2,
                    :@privately=>true,
                    :@receiver=>{:self=>{:@line=>2}},
                    :@check_for_local=>false}}],
               :@line=>3}},
           :@name=>:Y,
           :@line=>1}},
       :@name=>
        {:scopedmodulename=>
          {:@parent=>{:constfind=>{:@name=>:X, :@line=>1}},
           :@name=>:Y,
           :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
