module PachubeDataFormats
  module ActiveRecord
    module InstanceMethods
      # Provides data formatters methods for Pachube object classes
      #
      # Outputs Pachube v2 JSON "1.0.0"
      # Optionally outputs Pachube v1 JSON "0.6-alpha"
      #
      def to_pachube_json(version = "1.0.0")
        PachubeDataFormats::Feed.new(attributes.merge("datastreams" => datastreams.map(&:attributes))).to_json(:version => version)
      end
    end
  end
end

