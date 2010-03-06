require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'

begin
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
  Rake::RDocTask.new(:rdoc) do |t|
    t.rdoc_dir = 'doc'
    t.title    = 'Melbourne'
    t.options << '--line-numbers' << '--inline-source'
    t.rdoc_files.include('README.rdoc')
    t.rdoc_files.include('lib/**/*.rb')
  end

  desc 'compile the C extension'
  Rake::ExtensionTask.new('melbourne') do |ext|
    ext.lib_dir = File.join('lib', 'ext')
  end
  Rake::Task[:spec].prerequisites << :compile
rescue LoadError
  puts 'You need to install the rake-compiler gem.'
end

begin
  require 'simplabs/excellent/rake'

  desc 'Analyse the Melbourne source with Excellent.'
  Simplabs::Excellent::Rake::ExcellentTask.new(:excellent) do |t|
    t.html  = 'doc/excellent.html'
    t.paths = ['lib']
  end
rescue LoadError
  puts 'Install the excellent gem for source code analysis.'
end
