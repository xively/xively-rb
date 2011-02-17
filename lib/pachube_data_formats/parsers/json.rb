module PachubeDataFormats
  module FeedParser
    class JSON
      def self.parse(input)
        hash = Yajl::Parser.parse(input)
        hash['retrieved_at'] = hash.delete('updated')
        return hash
      end
    end
  end
end
