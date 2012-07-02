require 'rubygems'
require 'bundler/setup'

require 'rspec'

require 'time'

if !defined?(JRUBY_VERSION)
  if RUBY_VERSION < "1.9"
    require 'ruby-debug'
  else
    if ENV["COVERAGE"] == "on"
      require 'simplecov'
      SimpleCov.start do
        add_filter "/spec/"
      end
    end
  end
end

Dir['./spec/support/**/*.rb'].map {|f| require f}

$:.push File.expand_path("../lib", __FILE__)
require 'cosm-rb'

require File.dirname(__FILE__) + '/fixtures/models.rb'

RSpec.configure do |c|
  c.run_all_when_everything_filtered = true
end
