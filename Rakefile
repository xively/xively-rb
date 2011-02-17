require 'bundler/setup'

#require 'rake/testtask'
require 'rake/clean'
require 'rake/rdoctask'
require "rspec/core/rake_task"
require 'rcov/rcovtask'

CLEAN.include('pkg')
CLOBBER.include('html')

task :default => :spec

# run tests before building
task :build => :spec


desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w[--color --options "spec/spec.opts"]
end


desc "Run all specs with rcov"
Rcov::RcovTask.new do |t|
  t.test_files = FileList['spec/**/*_spec.rb']
  # t.verbose = true     # uncomment to see the executed command
  t.rcov_opts << '--exclude .gem/*,spec/*,features/*,.bundle/*,config/*'
end
