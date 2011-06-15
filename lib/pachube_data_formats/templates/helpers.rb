module PachubeDataFormats
  module Templates
    module Helpers

      protected

      def split_tags(tags)
        return [] if tags.blank?
        tags.split(',').flatten.map(&:strip).sort{|a,b| a.downcase <=> b.downcase}
      end
    end
  end
end

