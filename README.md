Melbourne
=========

Melbourne is [Rubinius](http://rubini.us)' parser component. The +melbourne+ gem extracts
this parser component for stand-alone use under MRI and other environments.

For Melbourne's full RDoc, see [rdoc.info](http://rdoc.info/projects/simplabs/melbourne).

Usage
-----

Melbourne generates abstract syntax trees (ASTs) from Ruby source code:

    require 'melbourne'

    'class Test; end'.to_ast # => <AST::Class:0x1017800f8
                                    @line=1,
                                    @body=#<AST::EmptyBody:0x101780058 @line=1>,
                                    @name=#<AST::ClassName:0x101780080 @line=1, @superclass=#<AST::Nil:0x1017800a8 @line=1>, @name=:Test>,
                                    @superclass=#<AST::Nil:0x1017800a8 @line=1>>

Abstract Syntax Trees
---------------------

Abstract syntax trees allow for deep introspection of Ruby source code and are far
easier to handle than e.g. S-expressions as provided by [ParseTree](http://parsetree.rubyforge.org/)
and other gems.

For more information on abstract syntax trees, see [Wikipedia](http://en.wikipedia.org/wiki/Abstract_syntax_trees).

Authors
-------

The original code of Melbourne is part of the [Rubinius project](http://rubini.us/) and
was written by and is &copy; [Evan Phoenix](http://github.com/evanphx/).

Melbourne was extracted from Rubinius into this gem by [Marco Otte-Witte](http://simplabs.com).

Bugs/ Feature Requests
----------------------

the +melbourne+ gem is <b>not</b> maintained by the [Rubinius](http://rubini.us) team! If you encounter
bugs or have feature requests, refer to the [Github repository](http://simplabs.github.com/melbourne).