module PachubeDataFormats
  module Templates
    module DatapointJSONDefaults
      def generate_json
        template = Template.new(self, :json)
        template.at
        template.value
        template.output!
      end
    end
  end
end

