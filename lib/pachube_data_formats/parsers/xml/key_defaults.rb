module PachubeDataFormats
  module Parsers
    module XML
      module KeyDefaults
        def from_xml(xml)
          xml = Nokogiri.parse(xml)
          hash = {}
          hash["id"] = xml.at_xpath("//id").content if xml.at_xpath("//id")
          hash["expires_at"] = xml.at_xpath("//expires-at").content if xml.at_xpath("//expires-at")
          hash["key"] = xml.at_xpath("//api-key").content if xml.at_xpath("//api-key")
          hash["label"] = xml.at_xpath("//label").content if xml.at_xpath("//label")
          hash["user"] = xml.at_xpath("//user").content if xml.at_xpath("//user")

          hash["scopes"] = xml.xpath("//key/scopes/scope").collect { |scope|
            permissions = scope.xpath("permissions/permission").collect { |permission|
              permission.content.to_s.downcase
            }
            resources = scope.xpath("resources/resource").collect { |resource|
              { "feed_id" => resource.at_xpath("feed-id").content,
                "datastream_id" => resource.at_xpath("datastream-id").content,
                "datastream_trigger_id" => resource.at_xpath("datastream-trigger-id").content
              }.delete_if_nil_value
            }
            {
              "referer" => scope.at_xpath("referer").content,
              "source_ip" => scope.at_xpath("source-ip").content,
              "private_access" => scope.at_xpath("private-access").content,
              "permissions" => permissions,
              "resources" => resources
            }.delete_if_nil_value
          }

          hash
        end
      end
    end
  end
end

