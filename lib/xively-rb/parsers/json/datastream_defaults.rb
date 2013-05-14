module Xively
  module Parsers
    module JSON
      module DatastreamDefaults
        def from_json(json)
          begin
            hash = MultiJson.load(json)
          rescue MultiJson::DecodeError => e
            raise InvalidJSONError, e.message
          end
          raise InvalidJSONError, "JSON doesn't appear to be a hash" unless hash.is_a?(Hash)
          case hash['version']
          when '0.6-alpha'
            transform_0_6_alpha(hash)
          when '1.0.0', nil
            transform_1_0_0(hash)
          end
        end

        private

        # As produced by http://xively.com/api/v2/FEED_ID/datastreams/DATASTREAM_ID.json
        def transform_1_0_0(hash)
          hash["id"] = hash.delete("id")
          hash["updated"] = hash.delete("at")
          hash["current_value"] = hash.delete("current_value")
          hash["tags"] = join_tags(hash["tags"])
          if unit = hash.delete('unit')
            hash['unit_type'] = unit['type']
            hash['unit_symbol'] = unit['symbol']
            hash['unit_label'] = unit['label']
          end
          hash
        end

        # As produced by http://xively.com/api/v1/FEED_ID/datastreams/DATASTREAM_ID.json
        def transform_0_6_alpha(hash)
          hash["id"] = hash.delete("id")
          if values = [*hash["values"]].first
            hash["updated"] = hash["values"].first.delete("recorded_at")
            hash["current_value"] = hash["values"].first.delete("value")
            hash["max_value"] = hash["values"].first.delete("max_value")
            hash["min_value"] = hash["values"].first.delete("min_value")
          end
          hash["tags"] = join_tags(hash["tags"])
          if unit = hash.delete('unit')
            hash['unit_type'] = unit['type']
            hash['unit_symbol'] = unit['symbol']
            hash['unit_label'] = unit['label']
          end
          hash
        end

      end
    end
  end
end

