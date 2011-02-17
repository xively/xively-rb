module PachubeDataFormats
  module FeedFormats
    class JSON
      extend Generator
      extend Parser
      def self.parse(input)
        hash = ::JSON.parse(input)
        hash['retrieved_at'] = hash.delete('updated')
        return hash
      end

      def self.generate(hash)
        hash['updated'] = hash.delete('retrieved_at')
        hash['version'] = '1.0.0'
        ::JSON.generate(hash)
      end
    end
  end
end

