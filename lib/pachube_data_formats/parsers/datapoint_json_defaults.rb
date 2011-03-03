module PachubeDataFormats
  module Parsers
    module DatapointJSONDefaults
      def from_json(json)
        JSON.parse(json)
      end
    end
  end
end

