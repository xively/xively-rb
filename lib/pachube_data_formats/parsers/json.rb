module PachubeDataFormats
  module Encoder
    def encode(input)
      raise "Implement me"
    end
  end

  module Decoder
    def decode(hash)
      raise "Implement me"
    end
  end

  module FeedFormats
    class JSON
      extend Encoder
      extend Decoder
      def self.decode(input)
        hash = ::JSON.parse(input)
        hash['retrieved_at'] = hash.delete('updated')
        return hash
      end

      def self.encode(hash)
        hash['updated'] = hash.delete('retrieved_at')
        hash['version'] = '1.0.0'
        ::JSON.generate(hash)
      end
    end
  end
end

