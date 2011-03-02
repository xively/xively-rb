module PachubeDataFormats
  module Parsers
    module DatapointXMLDefaults
      def from_xml(xml)
        xml = Nokogiri.parse(xml)
        hash = {}
        environment = xml.at_xpath("//xmlns:environment")
        data = environment.at_xpath("xmlns:data")
        datapoint = data.at_xpath("xmlns:datapoints")
        value = datapoint.at_xpath("xmlns:value")
        hash["value"] = value.content
        hash["at"] = value.attributes["at"].value
        hash
      end
    end
  end
end

