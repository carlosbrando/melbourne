require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "class << self; 42; end"' do
    ruby = <<-ruby
        class << self
          42
        end
      ruby
    ast  = {:sclass=>
      {:@body=>
        {:sclassscope=>
          {:@body=>
            {:block=>
              {:@array=>[{:fixnumliteral=>{:@line=>2, :@value=>42}}], :@line=>3}},
           :@name=>nil,
           :@line=>1}},
       :@line=>1,
       :@receiver=>{:self=>{:@line=>1}}}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "class A; class << self ... end; class B; end ..."' do
    ruby = <<-ruby
        class A
          class << self
            a
          end
          class B
          end
        end
      ruby
    ast  = {:class=>
      {:@superclass=>{},
       :@body=>
        {:classscope=>
          {:@body=>
            {:block=>
              {:@array=>
                [{:sclass=>
                   {:@body=>
                     {:sclassscope=>
                       {:@body=>
                         {:block=>
                           {:@array=>
                             [{:send=>
                                {:@block=>nil,
                                 :@name=>:a,
                                 :@line=>3,
                                 :@privately=>true,
                                 :@receiver=>{:self=>{:@line=>3}},
                                 :@check_for_local=>false}}],
                            :@line=>4}},
                        :@name=>nil,
                        :@line=>2}},
                    :@line=>2,
                    :@receiver=>{:self=>{:@line=>2}}}},
                 {:class=>
                   {:@superclass=>{},
                    :@body=>{:emptybody=>{:@line=>5}},
                    :@name=>
                     {:classname=>{:@superclass=>{}, :@name=>:B, :@line=>5}},
                    :@line=>5}}],
               :@line=>2}},
           :@name=>:A,
           :@line=>1}},
       :@name=>{:classname=>{:@superclass=>{}, :@name=>:A, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "x = "a"; class << x; end"' do
    ruby = <<-ruby
        x = "a"
        class << x
        end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:x,
            :@line=>1,
            :@value=>{:stringliteral=>{:@string=>:a, :@line=>1}}}},
         {:sclass=>
           {:@body=>{:sclassscope=>{:@body=>nil, :@name=>nil, :@line=>2}},
            :@line=>2,
            :@receiver=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:x, :@line=>2}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "x = "a"; m do class << x ..."' do
    ruby = <<-ruby
        x = "a"
        m do
          class << x
          end
        end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:x,
            :@line=>1,
            :@value=>{:stringliteral=>{:@string=>:a, :@line=>1}}}},
         {:send=>
           {:@block=>
             {:iter=>
               {:@body=>
                 {:sclass=>
                   {:@body=>{:sclassscope=>{:@body=>nil, :@name=>nil, :@line=>3}},
                    :@line=>3,
                    :@receiver=>
                     {:localvariableaccess=>
                       {:@variable=>nil, :@name=>:x, :@line=>3}}}},
                :@line=>2,
                :@arguments=>
                 {:iterarguments=>
                   {:@block=>nil,
                    :@arity=>-1,
                    :@prelude=>nil,
                    :@optional=>0,
                    :@splat=>nil,
                    :@line=>2,
                    :@splat_index=>-2,
                    :@required_args=>0}}}},
            :@name=>:m,
            :@line=>2,
            :@privately=>true,
            :@receiver=>{:self=>{:@line=>2}},
            :@check_for_local=>false}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "x = "a"; class << x ..."' do
    ruby = <<-ruby
        x = "a"
        class << x
          self
        end
      ruby
    ast  = {:block=>
      {:@array=>
        [{:localvariableassignment=>
           {:@variable=>nil,
            :@name=>:x,
            :@line=>1,
            :@value=>{:stringliteral=>{:@string=>:a, :@line=>1}}}},
         {:sclass=>
           {:@body=>
             {:sclassscope=>
               {:@body=>{:block=>{:@array=>[{:self=>{:@line=>3}}], :@line=>4}},
                :@name=>nil,
                :@line=>2}},
            :@line=>2,
            :@receiver=>
             {:localvariableaccess=>{:@variable=>nil, :@name=>:x, :@line=>2}}}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
