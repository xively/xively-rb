require 'rubygems'
require 'bundler/setup'

require 'ruby-debug'

Dir['./spec/support/**/*.rb'].map {|f| require f}

$:.push File.expand_path("../lib", __FILE__)
require 'pachube_data_formats'
