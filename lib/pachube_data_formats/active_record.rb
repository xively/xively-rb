require 'pachube_data_formats/active_record/instance_methods'

module PachubeDataFormats
  # Adds core methods to ActiveRecord
  #
  # is_pachube_data_format:
  #   - specifies that this model represents all or part of a Pachube feed
  module ActiveRecord
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      # Provides methods for converting between the different Pachube API data formats
      # An example for a model representing a Pachube feed:
      #
      #   is_pachube_data_format :feed
      #
      # A datastream
      #
      #   is_pachube_data_format :datastream
      #
      # To specify custom field mappings or map methods onto a field
      #
      #   is_pachube_data_format :feed, {:title => :my_custom_instance_method, :status => :determine_feed_state}
      #
      def is_pachube_data_format(klass, options = {})
        cattr_accessor :pachube_data_format_mappings
        cattr_accessor :pachube_data_format_class
        self.pachube_data_format_mappings = options
        case klass
        when :feed
          self.pachube_data_format_class = PachubeDataFormats::Feed
        when :datastream
          self.pachube_data_format_class = PachubeDataFormats::Datastream
        else
          self.pachube_data_format_class = nil
        end
        send :include, PachubeDataFormats::ActiveRecord::InstanceMethods
      end
    end
  end
end

