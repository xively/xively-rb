module PachubeDataFormats
  module Parsers
    module DatastreamDefaults
      def from_json(json)
        hash = JSON.parse(json)
        case hash['version']
        when '1.0.0'
          transform_1_0_0(hash)
        when '0.6-alpha'
          transform_0_6_alpha(hash)
        end
      end

      private

      def transform_1_0_0(hash)
        hash["retrieved_at"] = hash.delete("at")
        hash["value"] = hash.delete("current_value")
        hash["tag_list"] = hash["tags"].join(',')
        if unit = hash.delete('unit')
          hash['unit_type'] = unit['type']
          hash['unit_symbol'] = unit['symbol']
          hash['unit_label'] = unit['label']
        end
        hash
      end

      def transform_0_6_alpha(hash)
        hash["retrieved_at"] = hash["values"].first.delete("recorded_at")
        hash["value"] = hash["values"].first.delete("value")
        hash["max_value"] = hash["values"].first.delete("max_value")
        hash["min_value"] = hash["values"].first.delete("min_value")
        hash["tag_list"] = hash["tags"].join(',')
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

