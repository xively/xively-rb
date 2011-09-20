require 'bundler/setup'

#require 'rake/testtask'
require 'rake/clean'
require 'rake/rdoctask'
require "rspec/core/rake_task"
require 'rcov/rcovtask'

CLEAN.include('pkg')
CLEAN.include('coverage')
CLOBBER.include('html')

task :default => :spec

# run tests before building
task :build => :spec

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new do |t|
end

desc "Run all specs with rcov"
RSpec::Core::RakeTask.new(:rcov => :clean) do |t|
  t.rcov = true
  t.rcov_opts = '--exclude .gem/*,spec/*,.bundle/*,config/*,.rvm/*'
end

namespace :spec do
  desc "Run all specs tagged with :focus => true"
  RSpec::Core::RakeTask.new(:focus) do |t|
    t.rspec_opts = "--tag focus"
    t.verbose = true
  end
end
