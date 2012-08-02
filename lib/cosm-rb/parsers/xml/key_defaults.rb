module Cosm
  module Parsers
    module XML
      module KeyDefaults
        def from_xml(xml)
          begin
            xml = Nokogiri::XML(xml) do |config|
              config.strict.nonet
            end
            hash = {}
            hash["id"] = xml.at_xpath("//id").content if xml.at_xpath("//id")
            hash["expires_at"] = xml.at_xpath("//expires-at").content if xml.at_xpath("//expires-at")
            hash["key"] = xml.at_xpath("//api-key").content if xml.at_xpath("//api-key")
            hash["label"] = xml.at_xpath("//label").content if xml.at_xpath("//label")
            hash["user"] = xml.at_xpath("//user").content if xml.at_xpath("//user")
            hash["private_access"] = xml.at_xpath("//private-access").content if xml.at_xpath("//private-access")

            hash["permissions"] = xml.xpath("//key/permissions/permission").collect { |permission|
              access_methods = permission.xpath("access-methods/access-method").collect { |method|
                method.content.to_s.downcase
              }
              resources = permission.xpath("resources/resource").collect { |resource|
                { "feed_id" => resource.at_xpath("feed-id").content,
                  "datastream_id" => resource.at_xpath("datastream-id").content,
                  "datastream_trigger_id" => resource.at_xpath("datastream-trigger-id").content
                }.delete_if_nil_value
              }
              {
                "referer" => permission.at_xpath("referer").content,
                "source_ip" => permission.at_xpath("source-ip").content,
                "private_access" => permission.at_xpath("private-access").content,
                "access_methods" => access_methods,
                "resources" => resources
              }.delete_if_nil_value
            }

            hash
          rescue Nokogiri::SyntaxError => e
            raise InvalidXMLError, e.message
          end
        end
      end
    end
  end
end

