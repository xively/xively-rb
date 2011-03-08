module PachubeDataFormats
  module Templates
    module XML
      module FeedDefaults
        include XMLHeaders
        include Helpers

        def generate_xml(version)
          case version
          when "0.5.1"
            xml_0_5_1
          when "5"
            xml_5
          end
        end

        private

        # As used by http://www.pachube.com/api/v2/FEED_ID/datastreams/DATASTREAM_ID.xml
        def xml_0_5_1
          builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
            xml.eeml(_eeml_0_5_1) do |eeml|
              eeml.environment(:updated => updated.iso8601(6), :id => id, :creator => creator) do |environment|
                environment.title title
                environment.feed "#{feed}.xml"
                environment.status status
                environment.description description
                environment.icon icon
                environment.website website
                environment.email email
                environment.private_ self.private
                split_tags(tags).each do |tag|
                  environment.tag tag
                end if tags
                environment.location({:disposition => location_disposition, :exposure => location_exposure, :domain => location_domain}.delete_if_nil_value) do |location|
                  location.name location_name
                  location.lat location_lat
                  location.lon location_lon
                  location.ele location_ele
                end
                datastreams.each do |ds|
                  environment.data(:id => ds.id) do |data|
                    split_tags(ds.tags).each do |tag|
                      data.tag tag
                    end if ds.tags
                    data.current_value ds.current_value, :at => ds.updated.iso8601(6)
                    data.max_value ds.max_value if ds.max_value
                    data.min_value ds.min_value if ds.min_value
                    data.unit ds.unit_label, {:type => ds.unit_type, :symbol => ds.unit_symbol}.delete_if_nil_value if ds.unit_label || ds.unit_symbol || ds.unit_type
                    data.datapoints do
                      ds.datapoints.each do |datapoint|
                        data.value(datapoint.value, "at" => datapoint.at.iso8601(6))
                      end
                    end if ds.datapoints.any?
                  end
                end if datastreams
              end
            end
          end
          builder.to_xml
        end

        # As used by http://www.pachube.com/api/v1/FEED_ID/datastreams/DATASTREAM_ID.xml
        def xml_5
          builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
            xml.eeml(_eeml_5) do |eeml|
              eeml.environment(:updated => updated.iso8601, :id => id, :creator => "http://www.haque.co.uk") do |environment|
                environment.title title
                environment.feed "#{feed}.xml"
                environment.status status
                environment.description description
                environment.icon icon
                environment.website website
                environment.email email
                environment.location({:disposition => location_disposition, :exposure => location_exposure, :domain => location_domain}.delete_if_nil_value) do |location|
                  location.name location_name
                  location.lat location_lat
                  location.lon location_lon
                  location.ele location_ele
                end
                datastreams.each do |ds|
                  environment.data(:id => ds.id) do |data|
                    split_tags(ds.tags).each do |tag|
                      data.tag tag
                    end if ds.tags
                    data.value ds.current_value, {:minValue => ds.min_value, :maxValue => ds.max_value}.delete_if_nil_value
                    data.unit ds.unit_label, {:type => ds.unit_type, :symbol => ds.unit_symbol}.delete_if_nil_value if ds.unit_label || ds.unit_symbol || ds.unit_type
                  end
                end if datastreams
              end
            end
          end
          builder.to_xml
        end

      end
    end
  end
end

