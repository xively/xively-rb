module PachubeDataFormats
  module ActiveRecord
    module InstanceMethods
      # Provides data formatters methods for Pachube object classes
      #
      # Outputs Pachube v2 JSON "1.0.0"
      # Optionally outputs Pachube v1 JSON "0.6-alpha"
      #
      def to_pachube_json(version = "1.0.0")
        new_feed.to_json(:version => version)
      end

      def as_pachube_json(version = "1.0.0")
        new_feed.as_json(:version => version)
      end

      protected

      def new_feed
        PachubeDataFormats::Feed.new(attributes_with_associations)
      end

      def attributes_with_associations
        attributes.merge("datastreams" => datastreams.map(&:attributes)).merge(custom_attributes)
      end

      def custom_attributes
        hash = {}
        self.pachube_data_format_mappings.each do |key, value|
          hash[key.to_s] = self.send(value)
        end
        hash
      end

    end
  end
end

