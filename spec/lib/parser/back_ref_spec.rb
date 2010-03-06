require File.dirname(__FILE__) + '/../../spec_helper'

describe Melbourne::Parser do

  it 'should correctly parse "[$&, $`, $\', $+]"' do
    ruby = <<-ruby
        [$&, $`, $', $+]
      ruby
    ast  = {:arrayliteral=>
      {:@body=>
        [{:backref=>{:@kind=>:&, :@line=>1}},
         {:backref=>{:@kind=>:`, :@line=>1}},
         {:backref=>{:@kind=>:"'", :@line=>1}},
         {:backref=>{:@kind=>:+, :@line=>1}}],
       :@line=>1}}

    ruby.should parse_as(ast)
  end

end
