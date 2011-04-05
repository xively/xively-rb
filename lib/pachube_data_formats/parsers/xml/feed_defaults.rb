module PachubeDataFormats
  module Parsers
    module XML
      module FeedDefaults
        def from_xml(xml)
          xml = Nokogiri.parse(xml)
          case xml.root.attributes["version"].value
          when "0.5.1"
            transform_0_5_1(xml)
          when "5"
            transform_5(xml)
          end
        end

        # As produced by http://www.pachube.com/api/v2/FEED_ID.xml
        def transform_0_5_1(xml)
          hash = {}
          environment = xml.at_xpath("//xmlns:environment")
          hash["updated"] = environment.attributes["updated"].value
          hash["creator"] = environment.attributes["creator"].value
          hash["title"] = environment.at_xpath("xmlns:title").content
          hash["feed"] = environment.at_xpath("xmlns:feed").content
          hash["status"] = environment.at_xpath("xmlns:status").content
          hash["description"] = environment.at_xpath("xmlns:description").content
          hash["icon"] = environment.at_xpath("xmlns:icon").content
          hash["website"] = environment.at_xpath("xmlns:website").content
          hash["email"] = environment.at_xpath("xmlns:email").content
          hash["private"] = environment.at_xpath("xmlns:private").content
          hash["tags"] = environment.xpath("xmlns:tag").collect(&:content).sort{|a,b| a.downcase <=> b.downcase}.join(',')
          location = environment.at_xpath("xmlns:location")
          if location
            hash["location_name"] = location.at_xpath("xmlns:name").content
            hash["location_lat"] = location.at_xpath("xmlns:lat").content
            hash["location_lon"] = location.at_xpath("xmlns:lon").content
            hash["location_ele"] = location.at_xpath("xmlns:ele").content
            hash["location_domain"] = location.attributes["domain"].value
            hash["location_exposure"] = location.attributes["exposure"].value
            hash["location_disposition"] = location.attributes["disposition"].value
          end
          hash["datastreams"] = environment.xpath("xmlns:data").collect do |datastream|
            current_value = datastream.at_xpath("xmlns:current_value")
            unit = datastream.at_xpath("xmlns:unit")
            {
              "id" => datastream.attributes["id"].value,
              "tags" => datastream.xpath("xmlns:tag").collect(&:content).sort{|a,b| a.downcase <=> b.downcase}.join(','),
              "current_value" => current_value.content,
              "updated" => current_value.attributes["at"].value,
              "min_value" => datastream.at_xpath("xmlns:min_value").content,
              "max_value" => datastream.at_xpath("xmlns:max_value").content,
              "unit_label" => unit.content,
              "unit_type" => unit.attributes["type"].value,
              "unit_symbol" => unit.attributes["symbol"].value,
              "datapoints" => datastream.xpath("xmlns:datapoints").collect do |datapoint|
              value = datapoint.at_xpath("xmlns:value")
              {
                "at" => value.attributes["at"].value,
                "value" => value.content,
              }
              end
            }
          end
          hash
        end

        # As produced by http://www.pachube.com/api/v1/FEED_ID.xml
        def transform_5(xml)
          hash = {}
          environment = xml.at_xpath("//xmlns:environment")
          hash["updated"] = environment.attributes["updated"].value
          hash["creator"] = "http://www.haque.co.uk"
          hash["title"] = environment.at_xpath("xmlns:title").content
          hash["feed"] = environment.at_xpath("xmlns:feed").content
          hash["status"] = environment.at_xpath("xmlns:status").content
          hash["description"] = environment.at_xpath("xmlns:description").content
          hash["icon"] = environment.at_xpath("xmlns:icon").content
          hash["website"] = environment.at_xpath("xmlns:website").content
          hash["email"] = environment.at_xpath("xmlns:email").content
          location = environment.at_xpath("xmlns:location")
          if location
            hash["location_name"] = location.at_xpath("xmlns:name").content
            hash["location_lat"] = location.at_xpath("xmlns:lat").content
            hash["location_lon"] = location.at_xpath("xmlns:lon").content
            hash["location_ele"] = location.at_xpath("xmlns:ele").content
            hash["location_domain"] = location.attributes["domain"].value
            hash["location_exposure"] = location.attributes["exposure"].value
            hash["location_disposition"] = location.attributes["disposition"].value
          end
          hash["datastreams"] = environment.xpath("xmlns:data").collect do |datastream|
            current_value = datastream.at_xpath("xmlns:value")
            unit = datastream.at_xpath("xmlns:unit")
            {
              "id" => datastream.attributes["id"].value,
              "tags" => datastream.xpath("xmlns:tag").collect(&:content).sort{|a,b| a.downcase <=> b.downcase}.join(','),
              "current_value" => current_value.content,
              "updated" => environment.attributes["updated"].value,
              "min_value" => current_value.attributes["minValue"].value,
              "max_value" => current_value.attributes["maxValue"].value,
              "unit_label" => unit.content,
              "unit_type" => unit.attributes["type"].value,
              "unit_symbol" => unit.attributes["symbol"].value,
            }
          end
          hash
        end
      end
    end
  end
end

