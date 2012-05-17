require 'cosm-rb/base/instance_methods'

module Cosm
  # Provide an interface for your model objects by extending this module:
  # extend Cosm::Base
  #
  # This provides the following configuration class method:
  # is_cosm:
  #   - specifies that this model represents all or part of a Cosm feed
  module Base

      # Provides methods for converting between the different Cosm API data formats
      # An example for a model representing a Cosm feed:
      #
      #   is_cosm :feed
      #
      # A datastream
      #
      #   is_cosm :datastream
      #
      # To specify custom field mappings or map methods onto a field
      #
      #   is_cosm :feed, {:title => :my_custom_instance_method, :status => :determine_feed_state}
      #
      def is_cosm(klass, options = {})
        @options = options
        case klass
        when :feed
          @cosm_class = Cosm::Feed
        when :datastream
          @cosm_class = Cosm::Datastream
        when :datapoint
          @cosm_class = Cosm::Datapoint
        else
          @cosm_class = nil
        end

        class << self
          def cosm_mappings
            @options
          end

          def cosm_class
            @cosm_class
          end
        end

        send :include, Cosm::Base::InstanceMethods
      end
  end
end

