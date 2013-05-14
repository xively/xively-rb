module Xively
  module Templates
    module JSON
      module DatastreamDefaults

        def generate_json(version, options={})
          if version == "1.0.0"
            output = json_100(options)
          elsif version == "0.6-alpha"
            output = json_06alpha(options)
          end
          output[:version] = version unless options[:hide_version]
          !options[:include_blank] ? output.delete_if_nil_value : output
        end

        private

        # As used by http://xively.com/api/v2/FEED_ID/datastreams/DATASTREAM_ID.json
        def json_100(options = {})
          datapoints = self.datapoints.map {|dp| {:value => dp.value, :at => dp.at.iso8601(6)}}
          {
            :id => self.id,
            :current_value => self.current_value,
            :at => self.updated.iso8601(6),
            :max_value => self.max_value.to_s,
            :min_value => self.min_value.to_s,
            :tags => parse_tag_string(self.tags),
            :unit => unit_hash(options),
            :datapoints_function => datapoints_function,
            :datapoints => datapoints
          }
        end

        # As used by http://xively.com/api/v1/FEED_ID/datastreams/DATASTREAM_ID.json
        def json_06alpha(options = {})
          {
            :id => self.id,
            :values =>
            [{
              :recorded_at => updated.iso8601,
              :value => current_value,
              :max_value => max_value.to_s,
              :min_value => min_value.to_s
            }.delete_if_nil_value],
            :tags => parse_tag_string(self.tags),
            :unit => unit_hash(options),
          }
        end

        def unit_hash(options={})
          hash = { :type => unit_type,
                   :symbol => unit_symbol,
                   :label => unit_label }
          !options[:include_blank] ? (hash.delete_if_nil_value if unit_type || unit_label || unit_symbol) : hash
        end

      end
    end
  end
end

