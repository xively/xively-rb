require 'rubygems'
require 'bundler/setup'

require 'rspec'
require 'ruby-debug'

require 'time'
# require 'activerecord'

Dir['./spec/support/**/*.rb'].map {|f| require f}

$:.push File.expand_path("../lib", __FILE__)
require 'pachube_data_formats'

# require File.dirname(__FILE__) + '/../init.rb'

require File.dirname(__FILE__) + '/fixtures/models.rb'

