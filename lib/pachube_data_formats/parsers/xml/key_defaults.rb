module PachubeDataFormats
  module Parsers
    module XML
      module KeyDefaults
        def from_xml(xml)
          xml = Nokogiri.parse(xml)
          hash = {}
          hash["id"] = xml.at_xpath("//id").content if xml.at_xpath("//id")
          hash["expires_at"] = xml.at_xpath("//expires-at").content if xml.at_xpath("//expires-at")
          hash["feed_id"] = xml.at_xpath("//feed-id").content if xml.at_xpath("//feed-id")
          hash["datastream_id"] = xml.at_xpath("//datastream-id").content if xml.at_xpath("//datastream-id")
          hash["key"] = xml.at_xpath("//api-key").content if xml.at_xpath("//api-key")

          hash["permissions"] = xml.xpath("//permissions").map { |permissions|
            permissions.xpath("//permission").map { |m| m.content.downcase }
          }.flatten

          hash["private_access"] = xml.at_xpath("//private-access").content if xml.at_xpath("//private-access")
          hash["referer"] = xml.at_xpath("//referer").content if xml.at_xpath("//referer")
          hash["source_ip"] = xml.at_xpath("//source-ip").content if xml.at_xpath("//source-ip")
          hash["user"] = xml.at_xpath("//user").content if xml.at_xpath("//user")
          hash["label"] = xml.at_xpath("//label").content if xml.at_xpath("//label")
          hash
        end
      end
    end
  end
end

