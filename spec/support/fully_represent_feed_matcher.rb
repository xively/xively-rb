RSpec::Matchers.define :fully_represent_feed do |format, formatted_feed|
  match do |feed|
    match_xml_feed(feed, formatted_feed) if format.to_sym == :xml
    match_json_feed(feed, formatted_feed) if format.to_sym == :json
  end

  failure_message_for_should do |feed|
    "expected #{feed} to fully represent #{formatted_feed}"
  end

  description do
    "expected #{formatted_feed.class} to be fully represented"
  end

  def match_xml_feed(feed, formatted_feed)
    xml = Nokogiri.parse(formatted_feed)
    case xml.root.attributes["version"].value
    when "0.5.1"
      environment = xml.at_xpath("//xmlns:environment")
      feed.title.should == environment.at_xpath("//xmlns:title").content
    else
      false
    end
  end

  def match_json_feed(feed, formatted_feed)
    json = JSON.parse(formatted_feed)
    case json['version']
    when '1.0.0'
      feed.title.should == json["title"]
      feed.status.should == json["status"]
      feed.creator.should == json["creator"]
      feed.updated.should == json["updated"]
      feed.website.should == json["website"]
      feed.private.should == json["private"]
      feed.feed.should == json["feed"]
      no_units = true
      feed.datastreams.should_not be_empty
      feed.datastreams.each do |datastream|
        ds = json['datastreams'].detect{|s| s["id"] == datastream.id}
        datastream.current_value.should == ds["current_value"]
        datastream.min_value.should == ds["min_value"]
        datastream.max_value.should == ds["max_value"]
        datastream.updated.should == ds["at"]
        datastream.tags.should == ds["tags"].join(',')
        if ds["unit"]
          no_units = false
          datastream.unit_label.should == ds["unit"]["label"]
          datastream.unit_symbol.should == ds["unit"]["symbol"]
          datastream.unit_type.should == ds["unit"]["type"]
        end
      end
      raise "This test is testing a feed with no datastream units" if no_units
      feed.id.should == json["id"]
      json["location"].should_not be_empty
      feed.location_disposition.should == json["location"]["disposition"]
      feed.location_domain.should == json["location"]["domain"]
      feed.location_ele.should == json["location"]["ele"]
      feed.location_exposure.should == json["location"]["exposure"]
      feed.location_lat.should == json["location"]["lat"]
      feed.location_lon.should == json["location"]["lon"]
      feed.location_name.should == json["location"]["name"]
    when '0.6-alpha'
      feed.title.should == json["title"]
      feed.status.should == json["status"]
      feed.updated.should == json["updated"]
      feed.website.should == json["website"]
      feed.private.should be_nil
      feed.feed.should == json["feed"]
      no_units = true
      feed.datastreams.should_not be_empty
      feed.datastreams.each do |datastream|
        ds = json['datastreams'].detect{|s| s["id"] == datastream.id}
        datastream.current_value.should == ds["values"].first["value"]
        datastream.min_value.should == ds["values"].first["min_value"]
        datastream.max_value.should == ds["values"].first["max_value"]
        datastream.updated.should == ds["values"].first["recorded_at"]
        datastream.tags.should == ds["tags"].join(',')
        if ds["unit"]
          no_units = false
          datastream.unit_label.should == ds["unit"]["label"]
          datastream.unit_symbol.should == ds["unit"]["symbol"]
          datastream.unit_type.should == ds["unit"]["type"]
        end
      end
      raise "This test is testing a feed with no datastream units" if no_units
      feed.id.should == json["id"]
      json["location"].should_not be_empty
      feed.location_disposition.should == json["location"]["disposition"]
      feed.location_domain.should == json["location"]["domain"]
      feed.location_ele.should == json["location"]["ele"]
      feed.location_exposure.should == json["location"]["exposure"]
      feed.location_lat.should == json["location"]["lat"]
      feed.location_lon.should == json["location"]["lon"]
      feed.location_name.should == json["location"]["name"]
    else
      false
    end
  end

end


