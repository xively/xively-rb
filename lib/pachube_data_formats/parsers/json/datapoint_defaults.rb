module PachubeDataFormats
  module Parsers
    module JSON
      module DatapointDefaults
        def from_json(json)
          ::JSON.parse(json)
        end
      end
    end
  end
end

