module PachubeDataFormats
  module Templates
    module DatastreamXMLDefaults
      include XMLHeaders

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
            eeml.environment(:updated => updated.iso8601(6), :id => feed_id, :creator => feed_creator) do |environment|
              environment.data(:id => id) do |data|
                split_tags(tags).each do |tag|
                  data.tag tag
                end if tags
                data.current_value current_value, :at => updated.iso8601(6)
                data.max_value max_value if max_value
                data.min_value min_value if min_value
                data.unit unit_label, {:type => unit_type, :symbol => unit_symbol}.delete_if_nil_value if unit_label || unit_type || unit_symbol
                data.datapoints do
                  datapoints.each do |datapoint|
                    data.value(datapoint.value, "at" => datapoint.at.iso8601(6))
                  end
                end if datapoints.any?
              end
            end
          end
        end
        builder.to_xml
      end

      # As used by http://www.pachube.com/api/v1/FEED_ID/datastreams/DATASTREAM_ID.xml
      def xml_5
        builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
          xml.eeml(_eeml_5) do |eeml|
            eeml.environment(:updated => updated.iso8601, :id => feed_id, :creator => "http://www.haque.co.uk") do |environment|
              environment.data(:id => id) do |data|
                split_tags(tags).each do |tag|
                  data.tag tag
                end if tags
                data.value current_value, {:minValue => min_value, :maxValue => max_value}.delete_if_nil_value
                data.unit unit_label, {:type => unit_type, :symbol => unit_symbol}.delete_if_nil_value if unit_label || unit_type || unit_symbol
              end
            end
          end
        end
        builder.to_xml
      end

      def split_tags(tags)
        tags.split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase}
      end
    end
  end
end

