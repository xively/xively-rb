module PachubeDataFormats
  module ActiveRecord
    module InstanceMethods
      # Provides data formatters methods for Pachube object classes
      #
      # Outputs Pachube v2 JSON
      #
      def to_pachube_json
        PachubeDataFormats::Feed.new(attributes).to_json
      end
    end
  end
end

