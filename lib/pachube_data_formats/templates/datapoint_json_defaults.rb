module PachubeDataFormats
  module Templates
    module DatapointJSONDefaults
      def generate_json
        template = Template.new(self, :json)
        template.at {at.iso8601(6)}
        template.value
        template.output!
      end
    end
  end
end

