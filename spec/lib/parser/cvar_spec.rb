require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "@@x"' do
    ruby = '@@x'
    ast  = {:classvariableaccess=>{:@name=>:@@x, :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "class A; @@a; end"' do
    ruby = <<-ruby
        class A
          @@a
        end
      ruby
    ast  = {:class=>
      {:@superclass=>{},
       :@body=>
        {:classscope=>
          {:@body=>
            {:block=>
              {:@array=>[{:classvariableaccess=>{:@name=>:@@a, :@line=>2}}],
               :@line=>3}},
           :@name=>:A,
           :@line=>1}},
       :@name=>{:classname=>{:@superclass=>{}, :@name=>:A, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

  it 'should correctly parse "module M; @@a; end"' do
    ruby = <<-ruby
        module M
          @@a
        end
      ruby
    ast  = {:module=>
      {:@body=>
        {:modulescope=>
          {:@body=>
            {:block=>
              {:@array=>[{:classvariableaccess=>{:@name=>:@@a, :@line=>2}}],
               :@line=>3}},
           :@name=>:M,
           :@line=>1}},
       :@name=>{:modulename=>{:@name=>:M, :@line=>1}},
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
