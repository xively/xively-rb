module Cosm
  module Parsers
    module JSON
      module SearchResultDefaults
        include FeedDefaults

        def from_json(json)
          begin
            hash = MultiJson.load(json)
          rescue MultiJson::DecodeError => e
            raise InvalidJSONError, e.message
          end
          raise InvalidJSONError, "JSON doesn't appear to be a hash" unless hash.is_a?(Hash)

          hash['results'] = hash['results'].collect do |feed|
            transform_1_0_0(feed)
          end
          hash
        end

      end
    end
  end
end
