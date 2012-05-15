module Cosm
  module Templates
    module JSON
      module FeedDefaults

        include Cosm::Helpers

        def generate_json(version, options = {})
          case version
          when "1.0.0"
            json_1_0_0 options
          when "0.6-alpha"
            json_0_6_alpha options
          end
        end

        private

        # As used by http://www.pachube.com/api/v2/FEED_ID.json
        def json_1_0_0(options = {})
          template = Template.new(self, :json)
          template.id
          template.title
          template.private {private.to_s}
          template.icon
          template.website
          template.tags {parse_tag_string(tags)} if tags
          template.description
          template.feed {feed.blank? ? "" : "#{feed}.json"}
          template.auto_feed_url
          template.status
          template.updated {updated.iso8601(6)}
          template.created {created.iso8601(6)}
          template.email
          template.creator
          if owner_login
            template.user do |user|
              {
                :login => owner_login
              }
            end
          end
          template.version {"1.0.0"}
          if datastreams
            template.datastreams do
              datastreams.collect do |ds|
                if ds.datapoints.any?
                  datapoints = ds.datapoints.collect {|dp| {:value => dp.value, :at => dp.at.iso8601(6)}}
                end
                {
                  :id => ds.id,
                  :at => ds.updated.iso8601(6),
                  :max_value => ds.max_value.to_s,
                  :min_value => ds.min_value.to_s,
                  :current_value => ds.current_value,
                  :tags => parse_tag_string(ds.tags),
                  :unit => unit_hash(ds, options),
                  :datapoints => datapoints
                }.delete_if_nil_value
              end
            end
          end
          template.location {location_hash(options)}
          template.output! options
        end

        # As used by http://www.pachube.com/api/v1/FEED_ID.json
        def json_0_6_alpha(options={})
          template = Template.new(self, :json)
          template.id
          template.title
          template.icon
          template.website
          template.description
          template.feed {"#{feed}.json"}
          template.status
          template.updated {updated.iso8601(6)}
          template.email
          template.version {"0.6-alpha"}
          if datastreams
            template.datastreams do
              datastreams.collect do |ds|
                {
                  :id => ds.id,
                  :values => [{
                  :max_value => ds.max_value.to_s,
                  :min_value => ds.min_value.to_s,
                  :value => ds.current_value,
                  :recorded_at => ds.updated.iso8601
                }.delete_if_nil_value],
                  :tags => parse_tag_string(ds.tags),
                  :unit => unit_hash(ds, options)
                }.delete_if_nil_value
              end
            end
          end
          template.location {location_hash(options)}
          template.output! options
        end

        private

        def location_hash(options={})
          hash = { :disposition => location_disposition,
            :name => location_name,
            :exposure => location_exposure,
            :domain => location_domain,
            :ele => location_ele,
            :lat => location_lat,
            :lon => location_lon }
          hash[:waypoints] = format_location_waypoints if location_waypoints
          !options[:include_blank] ? (hash.delete_if_nil_value if location_disposition || location_name || location_exposure || location_domain || location_ele || location_lat || location_lon) : hash
        end
        
        def format_location_waypoints
          output = []
          location_waypoints.each{ |item|
            output << item
            output.last[:at] = output.last[:at].iso8601(6)
          }
          output
        end
        
        def unit_hash(datastream, options={})
          hash = { :type => datastream.unit_type,
            :symbol => datastream.unit_symbol,
            :label => datastream.unit_label }
          !options[:include_blank] ? (hash.delete_if_nil_value if datastream.unit_type || datastream.unit_label || datastream.unit_symbol) : hash
        end
      end
    end
  end
end

