module PachubeDataFormats
  module FeedParser
    class JSON
      def self.parse(input)
        Yajl::Parser.parse(input)
      end
    end
  end
end
