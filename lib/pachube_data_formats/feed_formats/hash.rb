module PachubeDataFormats
  module FeedFormats
    class Hash
      extend Generator
      extend Parser

      def self.parse(input)
        input
      end

      def self.generate(hash)
        hash
      end

    end
  end
end

