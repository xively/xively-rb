module PachubeDataFormats
  module ActiveRecord
    module InstanceMethods
      # Provides data formatters methods for Pachube object classes
      #
      # Outputs Pachube v2 JSON "1.0.0"
      # Optionally outputs Pachube v1 JSON "0.6-alpha"
      #
      def to_pachube_json(version = "1.0.0")
        new_object.to_json(:version => version)
      end

      def as_pachube_json(version = "1.0.0")
        new_object.as_json(:version => version)
      end

      protected

      def new_object
        pachube_data_format_class.new(attributes_with_associations)
      end

      def attributes_with_associations
        attributes.merge(custom_pachube_attributes)
      end

      def custom_pachube_attributes
        hash = {}
        if self.respond_to?(:datastreams)
          hash["datastreams"] = self.datastreams.map{|ds| (ds.attributes.merge(ds.custom_pachube_attributes)) if ds.kind_of?(PachubeDataFormats::ActiveRecord::InstanceMethods)}
        end
        self.pachube_data_format_mappings.each do |key, value|
          hash[key.to_s] = self.send(value)
        end
        hash
      end

    end
  end
end

