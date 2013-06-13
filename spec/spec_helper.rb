require 'rubygems'
require 'bundler/setup'

require 'rspec'
require 'webmock/rspec'
require 'time'
require 'coveralls'
Coveralls.wear!

if !defined?(JRUBY_VERSION)
  if ENV["COVERAGE"] == "on"
    require 'simplecov'
    SimpleCov.start do
      add_filter "/spec/"
      add_filter "/lib/xively-rb.rb"
      add_filter "/vendor/"
      minimum_coverage 100
    end
  end
end

Dir['./spec/support/**/*.rb'].map {|f| require f}

$:.push File.expand_path("../lib", __FILE__)
require 'xively-rb'

require File.dirname(__FILE__) + '/fixtures/models.rb'

RSpec.configure do |c|
  c.run_all_when_everything_filtered = true
end
