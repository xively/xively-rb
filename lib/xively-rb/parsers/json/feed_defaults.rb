module Xively
  module Parsers
    module JSON
      class InvalidJSONError < Xively::ParserError; end
      module FeedDefaults

        include Xively::Helpers

        def from_json(json)
          begin
            hash = MultiJson.load(json)
          rescue MultiJson::DecodeError => e
            raise InvalidJSONError, e.message
          end
          raise InvalidJSONError, "JSON doesn't appear to be a hash" unless hash.is_a?(Hash)
          case hash['version']
          when '0.6-alpha', '0.6'
            transform_0_6_alpha(hash)
          else
            transform_1_0_0(hash)
          end
        end

        private

        # As produced by http://xively.com/api/v2/FEED_ID.json
        def transform_1_0_0(hash)
          hash["updated"] = hash["updated"]
          hash["created"] = hash["created"]
          hash["status"] = hash["status"]
          hash["tags"] = join_tags(hash["tags"])
          raise InvalidJSONError, "\"datastreams\" must be an array" unless hash["datastreams"].nil? || hash["datastreams"].is_a?(Array)
          hash["datastreams"] = [*hash["datastreams"]].collect do |datastream|
            unit_hash = {}
            if unit = datastream.delete('unit')
              unit_hash['unit_type'] = unit['type']
              unit_hash['unit_symbol'] = unit['symbol']
              unit_hash['unit_label'] = unit['label']
            end
            {
              "id" => datastream["id"],
              "current_value" => datastream["current_value"],
              "min_value" => datastream["min_value"],
              "max_value" => datastream["max_value"],
              "updated" => datastream["at"],
              "tags" => join_tags(datastream["tags"]),
              "datapoints" => setup_datapoints(datastream["datapoints"])
            }.merge(unit_hash)
          end if hash["datastreams"]
          if location = hash.delete("location")
            hash["location_disposition"] = location["disposition"]
            hash["location_domain"] = location["domain"]
            hash["location_ele"] = location["ele"]
            hash["location_exposure"] = location["exposure"]
            hash["location_lat"] = location["lat"]
            hash["location_lon"] = location["lon"]
            hash["location_name"] = location["name"]
          end
          if owner = hash.delete("user")
            hash["owner_login"] = owner["login"]
          end
          hash
        end

        # As produced by http://xively.com/api/v1/FEED_ID.json
        def transform_0_6_alpha(hash)
          hash["retrieved_at"] = hash["updated"]
          hash["state"] = hash["status"]
          if hash["datastreams"]
            hash["datastreams"] = hash["datastreams"].collect do |datastream|
              unit_hash = {}
              if unit = datastream.delete('unit')
                unit_hash['unit_type'] = unit['type']
                unit_hash['unit_symbol'] = unit['symbol']
                unit_hash['unit_label'] = unit['label']
              end
              value_hash = {}
              if datastream["values"].size >= 1
                value_hash["current_value"] = datastream["values"].first["value"]
                value_hash["min_value"] = datastream["values"].first["min_value"]
                value_hash["max_value"] = datastream["values"].first["max_value"]
                value_hash["updated"] = datastream["values"].first["recorded_at"]
              end
              {
                "id" => datastream["id"],
                "tags" => join_tags(datastream["tags"]),
              }.merge(value_hash).merge(unit_hash)
            end
            if location = hash.delete("location")
              hash["location_disposition"] = location["disposition"]
              hash["location_domain"] = location["domain"]
              hash["location_ele"] = location["ele"]
              hash["location_exposure"] = location["exposure"]
              hash["location_lat"] = location["lat"]
              hash["location_lon"] = location["lon"]
              hash["location_name"] = location["name"]
            end
          end
          hash
        end

        def setup_datapoints(datapoints)
          return [] unless datapoints
          datapoints.collect do |datapoint|
            {
              "at" => datapoint["at"],
              "value" => datapoint["value"]
            }
          end
        end
      end
    end
  end
end

