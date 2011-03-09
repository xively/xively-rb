require 'nokogiri'
require 'yajl/json_gem'
require 'csv'
require 'pachube_data_formats/nil_content'
require 'pachube_data_formats/hash_extensions'
require 'pachube_data_formats/template'
require 'pachube_data_formats/templates/defaults'
require 'pachube_data_formats/parsers/defaults'
require 'pachube_data_formats/feed'
require 'pachube_data_formats/datastream'
require 'pachube_data_formats/datapoint'
require 'pachube_data_formats/search_result'

begin
  require 'activerecord'
rescue LoadError
  # No ActiveRecord present
else
  # ActiveRecord is present
  require 'pachube_data_formats/active_record'
  ActiveRecord::Base.send :include, PachubeDataFormats::ActiveRecord
end
