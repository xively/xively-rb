require 'nokogiri'
require 'yajl/json_gem'
require 'pachube_data_formats/nil_content'
require 'pachube_data_formats/template'
require 'pachube_data_formats/templates/xml_headers'
require 'pachube_data_formats/templates/feed_json_defaults'
require 'pachube_data_formats/templates/feed_xml_defaults'
require 'pachube_data_formats/templates/datastream_json_defaults'
require 'pachube_data_formats/templates/datastream_xml_defaults'
require 'pachube_data_formats/templates/datapoint_json_defaults'
require 'pachube_data_formats/templates/datapoint_xml_defaults'
require 'pachube_data_formats/parsers/datastream_json_defaults'
require 'pachube_data_formats/parsers/datastream_xml_defaults'
require 'pachube_data_formats/parsers/datapoint_json_defaults'
require 'pachube_data_formats/parsers/datapoint_xml_defaults'
require 'pachube_data_formats/parsers/feed_json_defaults'
require 'pachube_data_formats/parsers/feed_xml_defaults'
require 'pachube_data_formats/feed'
require 'pachube_data_formats/datastream'
require 'pachube_data_formats/datapoint'

begin
  require 'activerecord'
rescue LoadError
  # No ActiveRecord present
else
  # ActiveRecord is present
  require 'pachube_data_formats/active_record'
  ActiveRecord::Base.send :include, PachubeDataFormats::ActiveRecord
end
