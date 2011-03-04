module PachubeDataFormats
  module ActiveRecord
    module InstanceMethods
      
      # Converts an ActiveRecord instance into it's equivalent PachubeDataFormats object
      #  this can then be used to convert into xml, json or csv
      def to_pachube
        pachube_data_format_class.new(attributes.merge(custom_pachube_attributes))
      end

      protected

      def custom_pachube_attributes(options = {})
        hash = {}
        self.pachube_data_format_mappings.each do |key, value|
          hash[key.to_s] = self.send(value)
        end
        hash
      end

    end
  end
end

