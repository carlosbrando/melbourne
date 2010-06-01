$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))

require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require

require 'lib/melbourne'

%w(matchers helpers).each do |directory|
  Dir["#{File.dirname(__FILE__)}/#{directory}/**/*.rb"].each { |file| require file }
end
