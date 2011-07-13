# $LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'ext'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
# $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'riak-client','lib'))

# require File.join(file, "lib/melbourne")
require "melbourne"

p "1 + 1".to_sexp
