module Cosm
  module Templates
    module JSON
      module DatapointDefaults
        def generate_json(version = nil)
          {
            :at => at.iso8601(6),
            :value => value
          }.delete_if_nil_value
        end
      end
    end
  end
end

