module Cosm
  module Parsers
    module XML
      module TriggerDefaults
        def from_xml(xml)
          begin
            xml = Nokogiri::XML(xml) do |config|
              config.strict.nonet
            end
            hash = {}
            hash["id"] = xml.at_xpath("//id").content if xml.at_xpath("//id")
            hash["url"] = xml.at_xpath("//url").content if xml.at_xpath("//url")
            hash["trigger_type"] = xml.at_xpath("//trigger-type").content if xml.at_xpath("//trigger-type")
            hash["threshold_value"] = xml.at_xpath("//threshold-value").content if xml.at_xpath("//threshold-value")
            hash["notified_at"] = xml.at_xpath("//notified-at").content if xml.at_xpath("//notified-at")
            hash["user"] = xml.at_xpath("//user").content if xml.at_xpath("//user")
            hash["environment_id"] = xml.at_xpath("//environment-id").content if xml.at_xpath("//environment-id")
            hash["stream_id"] = xml.at_xpath("//stream-id").content if xml.at_xpath("//stream-id")
            hash
          rescue Nokogiri::SyntaxError => e
            raise InvalidXMLError, e.message
          end
        end
      end
    end
  end
end

