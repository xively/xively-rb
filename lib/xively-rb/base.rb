require 'xively-rb/base/instance_methods'

module Xively
  # Provide an interface for your model objects by extending this module:
  # extend Xively::Base
  #
  # This provides the following configuration class method:
  # is_xively:
  #   - specifies that this model represents all or part of a Xively feed
  module Base

      # Provides methods for converting between the different Xively API data formats
      # An example for a model representing a Xively feed:
      #
      #   is_xively :feed
      #
      # A datastream
      #
      #   is_xively :datastream
      #
      # To specify custom field mappings or map methods onto a field
      #
      #   is_xively :feed, {:title => :my_custom_instance_method, :status => :determine_feed_state}
      #
      def is_xively(klass, options = {})
        @options = options
        case klass
        when :feed
          @xively_class = Xively::Feed
        when :datastream
          @xively_class = Xively::Datastream
        when :datapoint
          @xively_class = Xively::Datapoint
        else
          @xively_class = nil
        end

        class << self
          def xively_mappings
            @options
          end

          def xively_class
            @xively_class
          end
        end

        send :include, Xively::Base::InstanceMethods
      end
  end
end

