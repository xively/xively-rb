module PachubeDataFormats
  module Templates
    module JSON
      module DatapointDefaults
        def generate_json(version = nil)
          template = Template.new(self, :json)
          template.at {at.iso8601(6)}
          template.value
          template.output!
        end
      end
    end
  end
end

