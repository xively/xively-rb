module Xively
  module Base
    module InstanceMethods

      # Converts a model that extends Xively::Base into it's equivalent Xively object
      #  this can then be used to convert into xml, json or csv
      def to_xively
        attributes = {}
        self.class.xively_class::ALLOWED_KEYS.each do |key|
          attributes[key] = self.send(key) if self.respond_to?(key)
        end
        self.class.xively_class.new(attributes.merge(custom_xively_attributes))
      end

      protected

      def custom_xively_attributes(options = {})
        hash = {}
        self.class.xively_mappings.each do |key, value|
          hash[key.to_s] = self.send(value)
        end
        hash
      end

    end
  end
end

