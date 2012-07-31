module Cosm
  module Parsers
    module JSON
      module KeyDefaults
        def from_json(json)
          begin
            hash = ::JSON.parse(json)["key"]
          rescue ::JSON::ParserError => e
            raise InvalidJSONError, e.message
          end
          raise InvalidJSONError, "JSON doesn't appear to be a hash" unless hash.is_a?(Hash)
          hash["id"] = hash.delete("id")
          hash["key"] = hash.delete("api_key")
          hash
        end
      end
    end
  end
end

