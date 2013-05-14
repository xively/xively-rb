module Xively
  module Parsers
    module JSON
      module DatapointDefaults
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

