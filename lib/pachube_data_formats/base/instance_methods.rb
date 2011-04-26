module PachubeDataFormats
  module Base
    module InstanceMethods
      
      # Converts an ActiveRecord instance into it's equivalent PachubeDataFormats object
      #  this can then be used to convert into xml, json or csv
      def to_pachube
        attributes = {}
        self.class.pachube_data_format_class::ALLOWED_KEYS.each do |key|
          attributes[key] = self.send(key) if self.respond_to?(key)
        end
        self.class.pachube_data_format_class.new(attributes.merge(custom_pachube_attributes))
      end

      protected

      def custom_pachube_attributes(options = {})
        hash = {}
        self.class.pachube_data_format_mappings.each do |key, value|
          hash[key.to_s] = self.send(value)
        end
        hash
      end

    end
  end
end

