module Cosm
  module Parsers
    module XML
      module DatapointDefaults
        def from_xml(xml)
          begin
            xml = Nokogiri::XML(xml) do |config|
              config.strict.nonet
            end
            hash = {}
            environment = xml.at_xpath("//xmlns:environment")
            raise InvalidXMLError, "Missing 'environment' node from base node" if environment.nil?
            data = environment.at_xpath("xmlns:data")
            datapoint = data.at_xpath("xmlns:datapoints")
            value = datapoint.at_xpath("xmlns:value")
            hash["value"] = value.content
            hash["at"] = value.attributes["at"].value
            hash
          rescue Nokogiri::SyntaxError => e
            raise InvalidXMLError, e.message
          end
        end
      end
    end
  end
end

