require 'bundler/setup'

#require 'rake/testtask'
require 'rake/clean'
require 'rake/task'
require "rspec/core/rake_task"

CLEAN.include('pkg')
CLEAN.include('coverage')
CLOBBER.include('html')

Bundler::GemHelper.install_tasks

task :default => :spec

# run tests before building
task :build => :spec

namespace :spec do
  desc "Run all specs tagged with :focus => true"
  RSpec::Core::RakeTask.new(:focus) do |t|
    t.rspec_opts = "--tag focus"
    t.verbose = true
  end
end
