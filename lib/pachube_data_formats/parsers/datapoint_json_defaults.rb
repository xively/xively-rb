module PachubeDataFormats
  module Parsers
    module DatapointJSONDefaults
      def from_json(json)
        hash = JSON.parse(json)
        #case hash['version']
        #when '1.0.0'
        #  transform_1_0_0(hash)
        #when '0.6-alpha'
        #  transform_0_6_alpha(hash)
        #end
      end
    end
  end
end

