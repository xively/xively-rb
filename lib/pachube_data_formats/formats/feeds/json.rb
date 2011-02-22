module PachubeDataFormats
  module Formats
    module Feeds
      class JSON < Base
        def self.parse(input)
          hash = ::JSON.parse(input)
          hash['retrieved_at'] = hash.delete('updated')
          hash['tag_list'] = hash.delete('tags').join(',')
          return hash
        end

        def self.generate(hash)
          hash['updated'] = hash.delete('retrieved_at') if hash['retrieved_at']
          hash['tags'] = hash.delete('tag_list').split(',').map(&:strip).sort if hash['tag_list']
          hash
        end
      end
    end
  end
end

