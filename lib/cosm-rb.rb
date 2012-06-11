require 'nokogiri'
if defined?(JRUBY_VERSION)
  require 'json/pure'
else
  require 'yajl/json_gem'
end
require 'csv'

$:.unshift(File.dirname(File.expand_path(__FILE__)))

$KCODE = 'u' if RUBY_VERSION.to_f < 1.9

require 'cosm-rb/helpers'
require 'cosm-rb/base'
require 'cosm-rb/validations'
require 'cosm-rb/object_extensions'
require 'cosm-rb/nil_content'
require 'cosm-rb/string_extensions'
require 'cosm-rb/array_extensions'
require 'cosm-rb/hash_extensions'
require 'cosm-rb/template'
require 'cosm-rb/templates/defaults'
require 'cosm-rb/parsers/defaults'
require 'cosm-rb/feed'
require 'cosm-rb/datastream'
require 'cosm-rb/datapoint'
require 'cosm-rb/search_result'
require 'cosm-rb/trigger'
require 'cosm-rb/key'
require 'cosm-rb/permission'
require 'cosm-rb/resource'

require 'cosm-rb/client'
