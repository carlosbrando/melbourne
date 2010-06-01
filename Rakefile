require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require

require 'spec/rake/spectask'
require 'simplabs/excellent/rake'
require 'rake/extensiontask'

desc 'Default: run specs.'
task :default => :spec

desc 'Run the specs.'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts << '--color'
  t.spec_opts << '--format=html:doc/spec.html'
  t.spec_opts << '--format=specdoc'
  t.rcov_opts << '--exclude "gems/*,spec/*,init.rb"'
  t.rcov       = true
  t.rcov_dir   = 'doc/coverage'
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Generate documentation for the Melbourne gem.'
YARD::Rake::YardocTask.new(:doc) do |t|
  t.files   = ['lib/**/*.rb', '-', 'HISTORY.md']
  t.options = ['--no-private', '--title', 'Melbourne Documentation']
end

desc 'compile the C extension'
Rake::ExtensionTask.new('melbourne') do |ext|
  ext.lib_dir = File.join('lib', 'ext')
end
Rake::Task[:spec].prerequisites << :compile

desc 'Analyse the Melbourne source with Excellent.'
Simplabs::Excellent::Rake::ExcellentTask.new(:excellent) do |t|
  t.paths = ['lib']
end
