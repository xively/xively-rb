module Cosm
  module Templates
    module JSON
      module SearchResultDefaults

        include Helpers

        def generate_json(version)
          if version == "1.0.0"
            json_100.delete_if_nil_value
          elsif version == "0.6-alpha"
            json_06alpha.delete_if_nil_value
          end
        end

        private

        # As used by http://cosm.com/api/v2/feeds.json
        def json_100
          {
            :totalResults => totalResults,
            :startIndex => startIndex,
            :itemsPerPage => itemsPerPage,
            :results => results.collect{|f| f.generate_json("1.0.0")}
          }
        end

        # As used by http://cosm.com/api/v1/feeds.json
        def json_06alpha
          {
            :totalResults => totalResults,
            :startIndex => startIndex,
            :itemsPerPage => itemsPerPage,
            :results => results.collect{|f| f.generate_json("0.6-alpha")}
          }
        end

      end
    end
  end
end

