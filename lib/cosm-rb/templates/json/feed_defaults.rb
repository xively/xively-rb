module Cosm
  module Templates
    module JSON
      module FeedDefaults

        include Cosm::Helpers

        def generate_json(version, options = {})
          if version == "1.0.0"
            output = json_100(options)
          elsif version == "0.6-alpha"
            output = json_06alpha(options)
          end
          !options[:include_blank] ? output.delete_if_nil_value : output
        end

        private

        # As used by http://cosm.com/api/v2/FEED_ID.json
        def json_100(options = {})
          {
            :id => self.id,
            :title => self.title,
            :private => self.private.to_s,
            :icon => icon,
            :website => website,
            :tags => parse_tag_string(tags),
            :description => self.description,
            :feed  => (feed.blank? ? "" : "#{feed}.json"),
            :auto_feed_url => auto_feed_url,
            :status => status,
            :updated => updated.iso8601(6),
            :created => created.iso8601(6),
            :email => email,
            :creator => creator,
            :user => ({ :login => owner_login } if owner_login),
            :version => "1.0.0",
            :datastreams => datastreams.map {|ds| ds.generate_json("1.0.0", options.merge({:hide_version => true}))},
            :location => location_hash(options)
          }
        end


        # As used by http://cosm.com/api/v1/FEED_ID.json
        def json_06alpha(options = {})
          {
            :id => self.id,
            :title => self.title,
            :icon => icon,
            :website => website,
            :description => self.description,
            :feed  => (feed.blank? ? "" : "#{feed}.json"),
            :status => status,
            :updated => updated.iso8601(6),
            :email => email,
            :version => "0.6-alpha",
            :datastreams => datastreams.map {|ds| ds.generate_json("0.6-alpha", options.merge({:hide_version => true}))},
            :location => location_hash(options)
          }
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
      end
    end
  end
end

