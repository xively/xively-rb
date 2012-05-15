module Cosm
  module Parsers
    module JSON
      module SearchResultDefaults
        include FeedDefaults

        def from_json(json)
          hash = ::JSON.parse(json)
          hash['results'] = hash['results'].collect do |feed|
            transform_1_0_0(feed)
          end
          hash
        end

      end
    end
  end
end
