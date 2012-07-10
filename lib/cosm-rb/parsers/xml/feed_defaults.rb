module Cosm
  module Parsers
    module XML
      class InvalidXMLError < StandardError; end
      module FeedDefaults
        def from_xml(xml)
          xml = Nokogiri.parse(xml)
          case xml.root.attributes["version"].value
          when "0.5.1"
            transform_0_5_1(xml)
          else
            transform_5(xml)
          end
        end

        # As produced by http://cosm.com/api/v2/FEED_ID.xml
        def transform_0_5_1(xml)
          hash = {}
          environment = xml.at_xpath("//xmlns:environment")
          raise InvalidXMLError, "Missing 'environment' node from base node" if environment.nil?
          hash["updated"] = environment.attributes["updated"].value
          hash["created"] = environment.attributes["created"].value
          hash["creator"] = environment.attributes["creator"].value
          hash["title"] = strip(environment.at_xpath("xmlns:title").content)
          hash["feed"] = strip(environment.at_xpath("xmlns:feed").content)
          hash["auto_feed_url"] = strip(environment.at_xpath("xmlns:auto_feed_url").content)
          hash["status"] = strip(environment.at_xpath("xmlns:status").content)
          hash["description"] = strip(environment.at_xpath("xmlns:description").content)
          hash["icon"] = strip(environment.at_xpath("xmlns:icon").content)
          hash["website"] = strip(environment.at_xpath("xmlns:website").content)
          hash["email"] = strip(environment.at_xpath("xmlns:email").content)
          hash["private"] = strip(environment.at_xpath("xmlns:private").content)
          if (tags = environment.xpath("xmlns:tag").collect { |t| t.content.strip }).any?
            hash["tags"] = Cosm::CSV.generate_line(tags.sort{|a,b| a.downcase <=> b.downcase}).strip
          end
          location = environment.at_xpath("xmlns:location")
          if location
            hash["location_name"] = strip(location.at_xpath("xmlns:name").content)
            hash["location_lat"] = strip(location.at_xpath("xmlns:lat").content)
            hash["location_lon"] = strip(location.at_xpath("xmlns:lon").content)
            hash["location_ele"] = strip(location.at_xpath("xmlns:ele").content)
            hash["location_domain"] = location.attributes["domain"].value
            hash["location_exposure"] = location.attributes["exposure"].value
            hash["location_disposition"] = location.attributes["disposition"].value
          end
          owner = environment.at_xpath("xmlns:user")
          if owner
            hash["owner_login"] = strip(owner.at_xpath("xmlns:login").content)
          end
          hash["datastreams"] = environment.xpath("xmlns:data").collect do |datastream|
            current_value = datastream.at_xpath("xmlns:current_value")
            if current_value
              value_hash = {
                "current_value" => strip(current_value.content),
                "updated" => current_value.attributes["at"].value,
              }
            else
              value_hash = {}
            end
            unit = datastream.at_xpath("xmlns:unit")
            if unit
              unit_hash = {
                "unit_label" => strip(unit.content),
                "unit_type" => unit.attributes["type"].value,
                "unit_symbol" => unit.attributes["symbol"].value,
              }
            else
              unit_hash = {}
            end
            if (tags = datastream.xpath("xmlns:tag").collect { |t| t.content.strip }).any?
              tags_hash = { "tags" => Cosm::CSV.generate_line(tags.sort { |a, b| a.downcase <=> b.downcase }).strip }
            else
              tags_hash = {}
            end
            {
              "id" => datastream.attributes["id"].value,
              "min_value" => strip(datastream.at_xpath("xmlns:min_value").content),
              "max_value" => strip(datastream.at_xpath("xmlns:max_value").content),
              "datapoints" => datastream.xpath("xmlns:datapoints").collect do |datapoint|
              value = datapoint.at_xpath("xmlns:value")
              {
                "at" => value.attributes["at"].value,
                "value" => strip(value.content),
              }
              end
            }.merge(value_hash).merge(unit_hash).merge(tags_hash)
          end
          hash
        end

        # As produced by http://cosm.com/api/v1/FEED_ID.xml
        def transform_5(xml)
          hash = {}
          environment = xml.at_xpath("//xmlns:environment")
          raise InvalidXMLError, "Missing 'environment' node from base node" if environment.nil?
          hash["updated"] = environment.attributes["updated"].value
          hash["creator"] = "http://www.haque.co.uk"
          hash["title"] = strip(environment.at_xpath("xmlns:title").content)
          hash["feed"] = strip(environment.at_xpath("xmlns:feed").content)
          hash["status"] = strip(environment.at_xpath("xmlns:status").content)
          hash["description"] = strip(environment.at_xpath("xmlns:description").content)
          hash["icon"] = strip(environment.at_xpath("xmlns:icon").content)
          hash["website"] = strip(environment.at_xpath("xmlns:website").content)
          hash["email"] = strip(environment.at_xpath("xmlns:email").content)
          location = environment.at_xpath("xmlns:location")
          if location
            hash["location_name"] = strip(location.at_xpath("xmlns:name").content)
            hash["location_lat"] = strip(location.at_xpath("xmlns:lat").content)
            hash["location_lon"] = strip(location.at_xpath("xmlns:lon").content)
            hash["location_ele"] = strip(location.at_xpath("xmlns:ele").content)
            hash["location_domain"] = location.attributes["domain"].value
            hash["location_exposure"] = location.attributes["exposure"].value
            hash["location_disposition"] = location.attributes["disposition"].value
          end
          hash["datastreams"] = environment.xpath("xmlns:data").collect do |datastream|
            current_value = datastream.at_xpath("xmlns:value")
            unit = datastream.at_xpath("xmlns:unit")
            if unit
              unit_hash = {
                "unit_label" => strip(unit.content),
                "unit_type" => unit.attributes["type"].value,
                "unit_symbol" => unit.attributes["symbol"].value,
              }
            else
              unit_hash = {}
            end
            if (tags = datastream.xpath("xmlns:tag").collect { |t| t.content.strip }).any?
              tags_hash = { "tags" => Cosm::CSV.generate_line(tags.sort { |a, b| a.downcase <=> b.downcase }).strip }
            else
              tags_hash = {}
            end
            {
              "id" => datastream.attributes["id"].value,
              "current_value" => strip(current_value.content),
              "updated" => environment.attributes["updated"].value,
              "min_value" => current_value.attributes["minValue"].value,
              "max_value" => current_value.attributes["maxValue"].value,
            }.merge(unit_hash).merge(tags_hash)
          end
          hash
        end

        def strip(value)
          return value.nil? ? nil : value.strip
        end
        private :strip
      end
    end
  end
end

