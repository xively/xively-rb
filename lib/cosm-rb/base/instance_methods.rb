module Cosm
  module Base
    module InstanceMethods

      # Converts a model that extends Cosm::Base into it's equivalent Cosm object
      #  this can then be used to convert into xml, json or csv
      def to_cosm
        attributes = {}
        self.class.cosm_class::ALLOWED_KEYS.each do |key|
          attributes[key] = self.send(key) if self.respond_to?(key)
        end
        self.class.cosm_class.new(attributes.merge(custom_cosm_attributes))
      end

      protected

      def custom_cosm_attributes(options = {})
        hash = {}
        self.class.cosm_mappings.each do |key, value|
          hash[key.to_s] = self.send(value)
        end
        hash
      end

    end
  end
end

