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
      
      # As used by http://www.pachube.com/api/v2/FEED_ID/datastreams/DATASTREAM_ID.json
      def json_1_0_0
        template = Template.new(self, :json)
        template.id
        template.version {"1.0.0"}
        template.at {updated.iso8601(6)}
        template.current_value
        template.max_value {max_value.to_s}
        template.min_value {min_value.to_s}
        template.tags {tags.split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase}}
        template.unit {unit_hash}
        template.output!
      end

      # As used by http://www.pachube.com/api/v1/FEED_ID/datastreams/DATASTREAM_ID.json
      def json_0_6_alpha
        template = Template.new(self, :json)
        template.id
        template.version {"0.6-alpha"}
        template.values {
          [{ :recorded_at => updated.iso8601,
            :value => current_value,
            :max_value => max_value.to_s,
            :min_value => min_value.to_s }]
        }
        template.tags {tags.split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase}}
        template.unit {unit_hash}
        template.output!
      end

      def unit_hash
        { :type => unit_type,
          :symbol => unit_symbol,
          :label => unit_label }.delete_if{|k,v| v.blank?}
      end

    end
  end
end

