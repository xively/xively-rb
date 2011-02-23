module PachubeDataFormats
  module Templates
    module DatastreamDefaults
      def generate_json(version)
        case version
        when "1.0.0"
          json_1_0_0
        when "0.6-alpha"
          json_0_6_alpha
        end
      end

      private
      
      def json_1_0_0
        template = Template.new(self, :json)
        template.id
        template.version {"1.0.0"}
        template.at {retrieved_at}
        template.current_value {value}
        template.max_value
        template.min_value
        template.tags {tag_list.split(',').map(&:strip).sort}
        template.unit {{"label" => unit_label, "symbol" => unit_symbol, "type" => unit_type}}
        template.output!.stringify_keys
      end

      def json_0_6_alpha
        template = Template.new(self, :json)
        template.id
        template.version {"0.6-alpha"}
        template.values {
          { "recorded_at" => retrieved_at,
            "value" => value,
            "max_value" => max_value,
            "min_value" => min_value }
        }
        template.tags {tag_list.split(',').map(&:strip).sort}
        template.unit {{"label" => unit_label, "symbol" => unit_symbol, "type" => unit_type}}
        template.output!.stringify_keys
      end
    end
  end
end

