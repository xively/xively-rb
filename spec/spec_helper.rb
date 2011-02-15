require 'rubygems'
require 'bundler/setup'

Dir['./spec/support/**/*.rb'].map {|f| require f}

$:.push File.expand_path("../lib", __FILE__)
require 'pachube-data-formats'
