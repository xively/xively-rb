module PachubeDataFormats
  module Templates
    module Helpers

      protected

      def split_tags(tags)
        return unless tags
        tags.split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase}
      end
    end
  end
end

