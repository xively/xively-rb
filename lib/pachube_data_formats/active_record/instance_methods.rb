module PachubeDataFormats
  module ActiveRecord
    module InstanceMethods
      # Provides data formatters methods for Pachube object classes
      #
      # Outputs Pachube v2 JSON "1.0.0"
      # Optionally outputs Pachube v1 JSON "0.6-alpha"
      #
      def to_pachube_json(version = "1.0.0", options = {})
        new_object(options).to_json(:version => version)
      end

      def as_pachube_json(version = "1.0.0", options = {})
        new_object(options).as_json(:version => version)
      end

      def to_pachube_xml(version = "0.5.1", options = {})
        new_object(options).to_xml(:version => version)
      end

      protected

      def new_object(options = {})
        pachube_data_format_class.new(attributes_with_associations(options))
      end

      def attributes_with_associations(options = {})
        attributes.merge(custom_pachube_attributes(options))
      end

      def custom_pachube_attributes(options = {})
        hash = {}
        unless [*options[:exclude]].include?(:datastreams)
          if self.respond_to?(:datastreams)
            hash["datastreams"] = self.datastreams.map{|ds| (ds.attributes.merge(ds.custom_pachube_attributes)) if ds.kind_of?(PachubeDataFormats::ActiveRecord::InstanceMethods)}
          end
        end
        self.pachube_data_format_mappings.each do |key, value|
          hash[key.to_s] = self.send(value)
        end
        hash
      end

    end
  end
end

