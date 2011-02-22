require 'yajl/json_gem'
require 'pachube_data_formats/datastream_formats/base'
require 'pachube_data_formats/datastream_formats/pachube_json'
require 'pachube_data_formats/datastream_formats/pachube_hash'
require 'pachube_data_formats/feed_formats/base'
require 'pachube_data_formats/feed_formats/pachube_json'
require 'pachube_data_formats/feed_formats/pachube_hash'
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
