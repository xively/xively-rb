module PachubeDataFormats
  module Templates
    module DatastreamXMLDefaults
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
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.eeml(_eeml_0_5_1) do |eeml|
            eeml.environment(:updated => updated.iso8601(6)) do |environment|
              environment.data(:id => id) do |data|
                split_tags(tags).each do |tag|
                  data.tag tag
                end if tags
                data.current_value current_value, :at => updated.iso8601(6)
                data.max_value max_value
                data.min_value min_value
                data.unit unit_label, :type => unit_type, :symbol => unit_symbol
              end
            end
          end
        end
        builder.to_xml
      end

      # As used by http://www.pachube.com/api/v1/FEED_ID/datastreams/DATASTREAM_ID.xml
      def xml_5
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.eeml(_eeml_5) do |eeml|
            eeml.environment(:updated => updated.iso8601) do |environment|
              environment.data(:id => id) do |data|
                split_tags(tags).each do |tag|
                  data.tag tag
                end if tags
                data.value current_value, :minValue => min_value, :maxValue => max_value
                data.unit unit_label, :type => unit_type, :symbol => unit_symbol
              end
            end
          end
        end
        builder.to_xml
      end

      def _eeml_0_5_1
        {:xmlns => "http://www.eeml.org/xsd/0.5.1", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", :version => "0.5.1", "xsi:schemaLocation" => "http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"}
      end

      def _eeml_5
        {:xmlns => "http://www.eeml.org/xsd/005", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", :version => "5", "xsi:schemaLocation" => "http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"}
      end

      def split_tags(tags)
        tags.split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase}
      end
    end
  end
end

