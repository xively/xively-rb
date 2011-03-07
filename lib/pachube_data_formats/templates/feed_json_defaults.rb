module PachubeDataFormats
  module Templates
    module FeedJSONDefaults

      include Helpers

      def generate_json(version)
        case version
        when "1.0.0"
          json_1_0_0
        when "0.6-alpha"
          json_0_6_alpha
        end
      end

      private
      
      # As used by http://www.pachube.com/api/v2/FEED_ID.json
      def json_1_0_0
        template = Template.new(self, :json)
        template.id
        template.title
        template.private
        template.icon
        template.website
        template.tags {tags.split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase}} if tags
        template.description
        template.feed {"#{feed}.json"}
        template.status
        template.updated {updated.iso8601(6)}
        template.email
        template.creator
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
                :max_value => ds.max_value,
                :min_value => ds.min_value,
                :current_value => ds.current_value,
                :tags => split_tags(ds.tags),
                :unit => unit_hash(ds),
                :datapoints => datapoints
              }.delete_if_nil_value
            end
          end
        end
        template.location {location_hash}
        template.output!
      end

      # As used by http://www.pachube.com/api/v1/FEED_ID.json
      def json_0_6_alpha
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
                  :max_value => ds.max_value,
                  :min_value => ds.min_value,
                  :value => ds.current_value,
                  :recorded_at => ds.updated.iso8601
              }],
                :tags => split_tags(ds.tags),
                :unit => unit_hash(ds)
              }.delete_if_nil_value
            end
          end
        end
        template.location {location_hash}
        template.output!
      end

      private

      def location_hash
        {
          :disposition => location_disposition,
          :name => location_name,
          :exposure => location_exposure,
          :domain => location_domain,
          :ele => location_ele,
          :lat => location_lat,
          :lon => location_lon
        } if location_disposition || location_name || location_exposure || location_domain || location_ele || location_lat || location_lon
      end

      def unit_hash(datastream)
        {
          :type => datastream.unit_type,
          :symbol => datastream.unit_symbol,
          :label => datastream.unit_label
        } if datastream.unit_type || datastream.unit_label || datastream.unit_symbol
      end

    end
  end
end

