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
        template.id
        template.title
        template.private
        template.icon
        template.website
        template.tags {tags.split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase}}
        template.description
        template.feed
        template.status
        template.updated {updated.iso8601(6)}
        template.email
        template.version {"1.0.0"}
        if datastreams
          template.datastreams do
            datastreams.collect do |ds|
              {
                :id => ds.id,
                :at => ds.updated.iso8601(6),
                :max_value => ds.max_value,
                :min_value => ds.min_value,
                :current_value => ds.current_value,
                :tags => ds.tags.split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase},
                :unit => {
                  :type => ds.unit_type,
                  :symbol => ds.unit_symbol,
                  :label => ds.unit_label
                }
              }
            end
          end
        end
        template.output!
      end

      def json_0_6_alpha
        template = Template.new(self, :json)
        template.id
        template.title
        template.icon
        template.website
        template.description
        template.feed
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
                :tags => ds.tags.split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase},
                :unit => {
                  :type => ds.unit_type,
                  :symbol => ds.unit_symbol,
                  :label => ds.unit_label
                }
              }
            end
          end
        end
        template.output!
      end
    end
  end
end

