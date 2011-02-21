module PachubeDataFormats
  module FeedFormats
    class PachubeJSON < Base
      def self.parse(input)
        hash = ::JSON.parse(input)
        hash['retrieved_at'] = hash.delete('updated')
        return hash
      end

      def self.generate(hash)
        hash['updated'] = hash.delete('retrieved_at') if hash['retrieved_at']
        # hash['version'] = '1.0.0'
        hash
      end
    end
  end
end

