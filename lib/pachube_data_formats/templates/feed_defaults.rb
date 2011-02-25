module PachubeDataFormats
  module Templates
    module FeedDefaults
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
        template.title
        template.private
        template.icon
        template.website
        template.tags {tag_list.split(',').map(&:strip).sort}
        template.description
        template.feed
        template.status {state}
        template.updated {retrieved_at.iso8601(6)}
        template.email
        template.version {"1.0.0"}
        if datastreams
          template.datastreams do
            datastreams.collect do |ds|
              {
                "id" => ds.stream_id,
                "at" => ds.retrieved_at.iso8601(6),
                "max_value" => ds.max_value,
                "min_value" => ds.min_value,
                "current_value" => ds.value,
                "tags" => ds.tag_list.split(',').map(&:strip).sort
              }
            end
          end
        end
        template.output!.stringify_keys
      end

      def json_0_6_alpha
        template = Template.new(self, :json)
        template.title
        template.icon
        template.website
        template.description
        template.feed
        template.status {state}
        template.updated {retrieved_at.iso8601(6)}
        template.email
        template.version {"0.6-alpha"}
        if datastreams
          template.datastreams do
            datastreams.collect do |ds|
              {
                "id" => ds.stream_id,
                "values" => [{
                  "max_value" => ds.max_value,
                  "min_value" => ds.min_value,
                  "value" => ds.value,
                  "recorded_at" => ds.retrieved_at.iso8601
                }],
                "tags" => ds.tag_list.split(',').map(&:strip).sort
              }
            end
          end
        end
        template.output!.stringify_keys
      end
    end
  end
end

