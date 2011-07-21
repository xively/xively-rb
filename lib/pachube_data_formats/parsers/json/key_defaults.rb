module PachubeDataFormats
  module Parsers
    module JSON
      module KeyDefaults
        def from_json(json)
          hash = ::JSON.parse(json)
          hash["id"] = hash.delete("id")
          hash["key"] = hash.delete("api_key")
          hash
        end
      end
    end
  end
end

