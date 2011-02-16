require 'bundler/setup'
Bundler::GemHelper.install_tasks

#require 'rake/testtask'
require 'rake/clean'
require 'rake/rdoctask'
require "rspec/core/rake_task"

CLEAN.include('pkg')
CLOBBER.include('html')

task :default => :spec

# run tests before building
task :build => :spec

desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w[--color --options "spec/spec.opts"]
end
