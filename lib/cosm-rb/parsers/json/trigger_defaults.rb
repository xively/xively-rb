module Cosm
  module Parsers
    module JSON
      module TriggerDefaults
        def from_json(json)
          begin
            MultiJson.load(json)
          rescue MultiJson::DecodeError => e
            raise InvalidJSONError, e.message
          end
        end
      end
    end
  end
end

