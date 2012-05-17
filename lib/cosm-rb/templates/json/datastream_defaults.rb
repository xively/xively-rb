module Cosm
  module Templates
    module JSON
      module DatastreamDefaults
        def generate_json(version, options={})
          case version
          when "1.0.0"
            json_1_0_0 options
          when "0.6-alpha"
            json_0_6_alpha options
          end
        end

        private

        # As used by http://cosm.com/api/v2/FEED_ID/datastreams/DATASTREAM_ID.json
        def json_1_0_0(options={})
          template = Template.new(self, :json)
          template.id
          template.version {"1.0.0"}
          template.at {updated.iso8601(6)}
          template.current_value
          template.max_value {max_value.to_s}
          template.min_value {min_value.to_s}
          template.tags {parse_tag_string(tags)}
          template.unit {unit_hash(options)}
          template.datapoints_function
          template.datapoints do
            datapoints.collect do |datapoint|
              {
                :at => datapoint.at.iso8601(6),
                :value => datapoint.value
              }
            end
          end if datapoints.any?
          template.output! options
        end

        # As used by http://cosm.com/api/v1/FEED_ID/datastreams/DATASTREAM_ID.json
        def json_0_6_alpha(options={})
          template = Template.new(self, :json)
          template.id
          template.version {"0.6-alpha"}
          template.values {
            [{ :recorded_at => updated.iso8601,
              :value => current_value,
              :max_value => max_value.to_s,
              :min_value => min_value.to_s }.delete_if_nil_value]
          }
          template.tags {parse_tag_string(tags)}
          template.unit {unit_hash(options)}
          template.output! options
        end

        def unit_hash(options={})
          hash = { :type => unit_type,
                   :symbol => unit_symbol,
                   :label => unit_label }
          !options[:include_blank] ? hash.delete_if_nil_value : hash
        end

      end
    end
  end
end

