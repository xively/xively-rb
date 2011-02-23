require 'yajl/json_gem'
require 'pachube_data_formats/formats'
require 'pachube_data_formats/template'
require 'pachube_data_formats/templates/feed_defaults'
require 'pachube_data_formats/templates/datastream_defaults'
require 'pachube_data_formats/feed'
require 'pachube_data_formats/datastream'

begin
  require 'activerecord'
rescue LoadError
  # No ActiveRecord present
else
  # ActiveRecord is present
  require 'pachube_data_formats/active_record'
  ActiveRecord::Base.send :include, PachubeDataFormats::ActiveRecord
end
