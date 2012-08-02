module Cosm
  module Parsers
    module XML
      module DatastreamDefaults
        def from_xml(xml)
          begin
            xml = Nokogiri::XML(xml) do |config|
              config.strict.nonet
            end
          rescue Nokogiri::SyntaxError => e
            raise InvalidXMLError, e.message
          end
          case xml.root.attributes["version"].value
          when "5"
            transform_5(xml)
          else
            transform_0_5_1(xml)
          end
        end

        private

        # As produced by http://cosm.com/api/v2/FEED_ID/datastreams/DATASTREAM_ID.xml
        def transform_0_5_1(xml)
          hash = {}
          environment = xml.at_xpath("//xmlns:environment")
          raise InvalidXMLError, "Missing 'environment' node from base node" if environment.nil?
          data = environment.at_xpath("xmlns:data")
          hash["feed_id"] = environment.attributes["id"].value
          hash["feed_creator"] = environment.attributes["creator"].value
          hash["id"] = data.attributes["id"].value
          if (tags = data.xpath("xmlns:tag").collect { |t| t.content.strip }).any?
            hash["tags"] = Cosm::CSV.generate_line(tags.sort{|a,b| a.downcase <=> b.downcase}).strip
          end
          current_value = data.at_xpath("xmlns:current_value")
          hash["current_value"] = current_value.content
          hash["updated"] = current_value.attributes["at"].value
          hash["min_value"] = data.at_xpath("xmlns:min_value").content
          hash["max_value"] = data.at_xpath("xmlns:max_value").content
          unit = data.at_xpath("xmlns:unit")
          if unit
            hash["unit_label"] = unit.content
            hash["unit_symbol"] = unit.attributes["symbol"].value
            hash["unit_type"] = unit.attributes["type"].value
          end
          hash["datapoints"] = data.xpath("xmlns:datapoints").collect do |datapoint|
            value = datapoint.at_xpath("xmlns:value")
            {
              "value" => value.content,
              "at" => value.attributes["at"].value
            }
          end
          hash
        end

        # As produced by http://cosm.com/api/v1/FEED_ID/datastreams/DATASTREAM_ID.xml
        def transform_5(xml)
          hash = {}
          environment = xml.at_xpath("//xmlns:environment")
          raise InvalidXMLError, "Missing 'environment' node from base node" if environment.nil?
          data = environment.at_xpath("xmlns:data")
          hash["feed_id"] = environment.attributes["id"].value
          hash["feed_creator"] = "http://www.haque.co.uk"
          hash["updated"] = environment.attributes["updated"].value
          hash["id"] = data.attributes["id"].value
          if (tags = data.xpath("xmlns:tag").collect { |t| t.content.strip }).any?
            hash["tags"] = Cosm::CSV.generate_line(tags.sort{ |a,b| a.downcase <=> b.downcase }).strip
          end
          current_value = data.at_xpath("xmlns:value")
          hash["current_value"] = current_value.content
          hash["min_value"] = current_value.attributes["minValue"].value
          hash["max_value"] = current_value.attributes["maxValue"].value
          unit = data.at_xpath("xmlns:unit")
          if unit
            hash["unit_label"] = unit.content
            hash["unit_symbol"] = unit.attributes["symbol"].value
            hash["unit_type"] = unit.attributes["type"].value
          end
          hash
        end
      end
    end
  end
end

