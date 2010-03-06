base = File.dirname(__FILE__)

module Melbourne

  module AST #:nodoc:
  end

end

require File.join(base, 'ast/node')
require File.join(base, 'ast/self')
require File.join(base, 'ast/constants')
require File.join(base, 'ast/control_flow')
require File.join(base, 'ast/definitions')
require File.join(base, 'ast/exceptions')
require File.join(base, 'ast/file')
require File.join(base, 'ast/grapher')
require File.join(base, 'ast/literals')
require File.join(base, 'ast/operators')
require File.join(base, 'ast/sends')
require File.join(base, 'ast/values')
require File.join(base, 'ast/variables')
