module PachubeDataFormats
  module Formats
    class Base
      def self.parse(input)
        raise "Implement - self.parse(input)"
      end

      def self.generate(hash)
        raise "Implement - self.generate(hash)"
      end
    end
  end
end

