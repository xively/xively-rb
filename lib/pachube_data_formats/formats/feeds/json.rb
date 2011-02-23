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

        #def self.generate(hash)
        #  case hash["version"]
        #  when "0.6-alpha"
        #    hash['updated'] = hash.delete('retrieved_at') if hash['retrieved_at']
        #    hash.delete('private')
        #    hash.delete('tag_list')
        #  else # "1.0.0"
        #    hash['updated'] = hash.delete('retrieved_at') if hash['retrieved_at']
        #    hash['tags'] = hash.delete('tag_list').split(',').map(&:strip).sort if hash['tag_list']
        #  end
        #  if hash['datastreams']
        #    datastreams = hash['datastreams'].collect do |ds|
        #      ds.as_json(:version => hash["version"]) if ds.respond_to?('as_json')
        #    end
        #    hash['datastreams'] = datastreams
        #  end
        #  hash
        #end
      end
    end
  end
end

