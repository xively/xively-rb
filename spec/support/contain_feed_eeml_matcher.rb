RSpec::Matchers.define :contain_feed_eeml_for_version do |eeml_version|
  match do |xml|
    hash = feed_as_(:hash)
    case eeml_version
    when "0.5.1"
      environment = xml.at_xpath("//xmlns:environment")
      environment.attributes["updated"].value.should == hash["updated"].iso8601(6)
      environment.attributes["created"].value.should == hash["created"].iso8601(6)
      environment.attributes["id"].value.should == hash["id"].to_s
      environment.attributes["creator"].value.should == hash["creator"]
      environment.at_xpath("//xmlns:title").content.should == hash["title"]
      environment.at_xpath("//xmlns:feed").content.should == "#{hash["feed"]}.xml"
      environment.at_xpath("//xmlns:status").content.should == hash["status"]
      environment.at_xpath("//xmlns:private").content.should == hash["private"].to_s
      environment.at_xpath("//xmlns:description").content.should == hash["description"]
      environment.at_xpath("//xmlns:icon").content.should == hash["icon"]
      environment.at_xpath("//xmlns:website").content.should == hash["website"]
      environment.at_xpath("//xmlns:email").content.should == hash["email"]
      environment.at_xpath("//xmlns:product_id").content.should == hash["product_id"]
      environment.at_xpath("//xmlns:device_serial").content.should == hash["device_serial"]
      tags = environment.xpath("//xmlns:tag")
      hash["tags"].split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase}.each_with_index do |tag, index|
        tags[index].content.should == tag
      end
      location = environment.at_xpath("//xmlns:location")
      location.attributes["domain"].value.should == hash["location_domain"]
      location.attributes["exposure"].value.should == hash["location_exposure"]
      location.attributes["disposition"].value.should == hash["location_disposition"]
      location.at_xpath("//xmlns:name").content.should == hash["location_name"]
      location.at_xpath("//xmlns:lat").content.should == hash["location_lat"].to_s
      location.at_xpath("//xmlns:lon").content.should == hash["location_lon"].to_s
      location.at_xpath("//xmlns:ele").content.should == hash["location_ele"]
      hash["datastreams"].each do |ds_hash|
        datastream = environment.at_xpath("//xmlns:data[@id=#{ds_hash["id"]}]")
        tags = datastream.xpath("xmlns:tag")
        ds_hash["tags"].split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase}.each_with_index do |tag, index|
          tags[index].content.should == tag
        end if ds_hash["tags"]
        current_value = datastream.at_xpath("xmlns:current_value")
        current_value.content.should == ds_hash["current_value"]
        current_value.attributes["at"].value.should == ds_hash["updated"].iso8601(6)
        datastream.at_xpath("xmlns:max_value").content.should == ds_hash["max_value"].to_s
        datastream.at_xpath("xmlns:min_value").content.should == ds_hash["min_value"].to_s
        unit = datastream.at_xpath("xmlns:unit")
        unit.content.should == ds_hash["unit_label"] unless ds_hash["unit_label"].empty?
        unit.attributes["type"].value.should == ds_hash["unit_type"] unless ds_hash["unit_type"].empty?
        unit.attributes["symbol"].value.should == ds_hash["unit_symbol"] unless ds_hash["unit_symbol"].empty?
        ds_hash["datapoints"].each do |dp_hash|
          datapoint = datastream.at_xpath("xmlns:datapoints").at_xpath("xmlns:value[@at=\"#{dp_hash["at"].iso8601(6)}\"]")
          datapoint.content.should == dp_hash["value"]
        end if ds_hash["datapoints"]
      end
    when "5"
      environment = xml.at_xpath("//xmlns:environment")
      environment.attributes["updated"].value.should == hash["updated"].iso8601
      environment.attributes["id"].value.should == hash["id"].to_s
      environment.attributes["creator"].value.should == "http://www.haque.co.uk"
      environment.at_xpath("//xmlns:title").content.should == hash["title"]
      environment.at_xpath("//xmlns:feed").content.should == "#{hash["feed"]}.xml"
      environment.at_xpath("//xmlns:status").content.should == hash["status"]
      environment.at_xpath("//xmlns:description").content.should == hash["description"]
      environment.at_xpath("//xmlns:icon").content.should == hash["icon"]
      environment.at_xpath("//xmlns:website").content.should == hash["website"]
      environment.at_xpath("//xmlns:email").content.should == hash["email"]
      location = environment.at_xpath("//xmlns:location")
      location.attributes["domain"].value.should == hash["location_domain"]
      location.attributes["exposure"].value.should == hash["location_exposure"]
      location.attributes["disposition"].value.should == hash["location_disposition"]
      location.at_xpath("//xmlns:name").content.should == hash["location_name"]
      location.at_xpath("//xmlns:lat").content.should == hash["location_lat"].to_s
      location.at_xpath("//xmlns:lon").content.should == hash["location_lon"].to_s
      location.at_xpath("//xmlns:ele").content.should == hash["location_ele"]
      hash["datastreams"].each do |ds_hash|
        datastream = environment.at_xpath("//xmlns:data[@id=#{ds_hash["id"]}]")
        tags = datastream.xpath("xmlns:tag")
        ds_hash["tags"].split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase}.each_with_index do |tag, index|
          tags[index].content.should == tag
        end if ds_hash["tags"]
        current_value = datastream.at_xpath("xmlns:value")
        current_value.content.should == ds_hash["current_value"]
        current_value.attributes["minValue"].value.should == ds_hash["min_value"].to_s
        current_value.attributes["maxValue"].value.should == ds_hash["max_value"].to_s
        unit = datastream.at_xpath("xmlns:unit")
        unit.content.should == ds_hash["unit_label"] unless ds_hash["unit_label"].empty?
        unit.attributes["type"].value.should == ds_hash["unit_type"] unless ds_hash["unit_type"].empty?
        unit.attributes["symbol"].value.should == ds_hash["unit_symbol"] unless ds_hash["unit_symbol"].empty?
      end
    else
      false
    end
  end

  failure_message_for_should do |xml|
    "expected #{xml} to contain eeml version #{eeml_version}"
  end
end


