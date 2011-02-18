module PachubeDataFormats
  module DatastreamFormats
    class PachubeJSON < Base
      def self.parse(input)
        hash = ::JSON.parse(input)
        hash['retrieved_at'] = hash.delete('at')
        hash['value'] = hash.delete('current_value')
        hash['tag_list'] = hash.delete('tags').join(',')
        if unit = hash.delete('unit')
          hash['unit_type'] = unit['type']
          hash['unit_symbol'] = unit['symbol']
          hash['unit_label'] = unit['label']
        end
        return hash
      end

      def self.generate(hash)
        hash['at'] = hash.delete('retrieved_at')
        hash['current_value'] = hash.delete('value')
        hash['tags'] = hash.delete('tag_list').split(',')
        hash['unit'] = {
          'type' => hash.delete('unit_type'),
          'symbol' => hash.delete('unit_symbol'),
          'label' => hash.delete('unit_label')
        }
        ::JSON.generate(hash)
      end
    end
  end
end

