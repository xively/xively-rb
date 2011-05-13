module PachubeDataFormats
  module Parsers
    module JSON
      module TriggerDefaults
        def from_json(json)
          ::JSON.parse(json)
        end
      end
    end
  end
end

