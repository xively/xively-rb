module PachubeDataFormats
  module Templates
    module JSON
      module SearchResultDefaults

        include Helpers

        def generate_json(version)
          case version
          when "1.0.0"
            json_1_0_0
          when "0.6-alpha"
            json_0_6_alpha
          end
        end

        private

        # As used by http://www.pachube.com/api/v2/feeds.json
        def json_1_0_0
          template = Template.new(self, :json)
          template.totalResults
          template.startIndex
          template.itemsPerPage
          if feeds
            template.results {feeds.collect{|f| f.generate_json("1.0.0")}}
          end
          template.output!
        end

        # As used by http://www.pachube.com/api/v1/feeds.json
        def json_0_6_alpha
          template = Template.new(self, :json)
          template.totalResults
          template.startIndex
          template.itemsPerPage
          if feeds
            template.results {feeds.collect{|f| f.generate_json("0.6-alpha")}}
          end
          template.output!
        end

      end
    end
  end
end

