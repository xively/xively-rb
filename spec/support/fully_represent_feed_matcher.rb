RSpec::Matchers.define :fully_represent_feed do |format, formatted_feed|
  match do |feed|
    if format.to_sym == :xml
      match_xml_feed(feed, formatted_feed)
    elsif format.to_sym == :json
      match_json_feed(feed, formatted_feed)
    elsif format.to_sym == :csv_v2
      match_csv_v2_feed(feed, formatted_feed)
    elsif format.to_sym == :csv_v1
      match_csv_v1_feed(feed, formatted_feed)
    else
      raise "No matcher for #{format}"
    end
  end

  failure_message_for_should do |feed|
    "expected #{feed.attributes.inspect} to fully represent #{formatted_feed}"
  end

  description do
    "expected #{formatted_feed.class} to be fully represented"
  end

  def match_csv_v1_feed(feed, formatted_feed)
    csv = Cosm::CSV.parse(formatted_feed.strip)
    csv.length.should == 1
    csv = csv.first
    feed.datastreams.length.should == csv.length
    feed.datastreams.each_with_index do |datastream, stream_id|
      csv.detect {|d| d == datastream.current_value}.should_not be_nil
      datastream.id.should == stream_id.to_s
    end
  end

  def match_csv_v2_feed(feed, formatted_feed)
    csv = Cosm::CSV.parse(formatted_feed.strip)
    feed.datastreams.length.should == csv.length
    feed.datastreams.each do |datastream|
      row = csv.detect {|d| d.first == datastream.id}
      datastream.current_value.should == row.last
      if row.size == 3
        datastream.updated.iso8601.should == row[1]
      end
    end
  end

  def match_xml_feed(feed, formatted_feed)
    xml = Nokogiri.parse(formatted_feed)
    case xml.root.attributes["version"].value
    when "0.5.1"
      environment = xml.at_xpath("//xmlns:environment")
      feed.title.should == environment.at_xpath("xmlns:title").content
      feed.updated.should == environment.attributes["updated"].value
      feed.created.should == environment.attributes["created"].value
      feed.creator.should == environment.attributes["creator"].value
      feed.feed.should == environment.at_xpath("xmlns:feed").content
      if auto_feed_url = environment.at_xpath("xmlns:auto_feed_url")
        feed.auto_feed_url.should == auto_feed_url.content
      end
      feed.status.should == environment.at_xpath("xmlns:status").content
      feed.description.should == environment.at_xpath("xmlns:description").content
      feed.icon.should == environment.at_xpath("xmlns:icon").content
      feed.website.should == environment.at_xpath("xmlns:website").content
      feed.email.should == environment.at_xpath("xmlns:email").content
      feed.private.should == environment.at_xpath("xmlns:private").content
      if feed.tags
        feed.tags.should == environment.xpath("xmlns:tag").map(&:content).sort{|a,b| a.downcase<=>b.downcase}.join(',')
      end
      owner = environment.at_xpath("xmlns:user")
      if owner
        feed.owner_login.should == owner.at_xpath("xmlns:login").content
      end
      location = environment.at_xpath("xmlns:location")
      if location
        feed.location_name.should == location.at_xpath("xmlns:name").content
        feed.location_lat.should == location.at_xpath("xmlns:lat").content
        feed.location_lon.should == location.at_xpath("xmlns:lon").content
        feed.location_ele.should == location.at_xpath("xmlns:ele").content
        feed.location_domain.should == location.attributes["domain"].value
        feed.location_exposure.should == location.attributes["exposure"].value
        feed.location_disposition.should == location.attributes["disposition"].value
      end
      feed.datastreams.each do |ds|
        data = environment.at_xpath("xmlns:data[@id=\"#{ds.id}\"]")
        ds.id.should == data.attributes["id"].value
        if (tags = data.xpath("xmlns:tag").collect { |t| t.content.strip }).any?
          ds.tags.should == tags.sort{|a,b| a.downcase<=>b.downcase}.join(',')
        end
        current_value = data.at_xpath("xmlns:current_value")
        ds.current_value.should == current_value.content
        ds.updated.should == current_value.attributes["at"].value
        ds.min_value.should == data.at_xpath("xmlns:min_value").content
        ds.max_value.should == data.at_xpath("xmlns:max_value").content
        unit = data.at_xpath("xmlns:unit")
        if unit
          ds.unit_label.should == unit.content
          ds.unit_type.should == unit.attributes["type"].value if unit.attributes["type"]
          ds.unit_symbol.should == unit.attributes["symbol"].value if unit.attributes["symbol"]
        end
        ds.datapoints.each do |point|
          dp = data.at_xpath("xmlns:datapoints").at_xpath("xmlns:value[@at=\"#{point.at}\"]")
          point.value.should == dp.content
        end
      end
      true
    when "5"
      environment = xml.at_xpath("//xmlns:environment")
      feed.title.should == environment.at_xpath("xmlns:title").content
      feed.updated.should == environment.attributes["updated"].value
      feed.creator.should == "http://www.haque.co.uk"
      feed.feed.should == environment.at_xpath("xmlns:feed").content
      feed.status.should == environment.at_xpath("xmlns:status").content
      feed.description.should == environment.at_xpath("xmlns:description").content
      feed.icon.should == environment.at_xpath("xmlns:icon").content
      feed.website.should == environment.at_xpath("xmlns:website").content
      feed.email.should == environment.at_xpath("xmlns:email").content
      location = environment.at_xpath("xmlns:location")
      if location
        feed.location_name.should == location.at_xpath("xmlns:name").content
        feed.location_lat.should == location.at_xpath("xmlns:lat").content
        feed.location_lon.should == location.at_xpath("xmlns:lon").content
        feed.location_ele.should == location.at_xpath("xmlns:ele").content
        feed.location_domain.should == location.attributes["domain"].value
        feed.location_exposure.should == location.attributes["exposure"].value
        feed.location_disposition.should == location.attributes["disposition"].value
      end
      feed.datastreams.each do |ds|
        data = environment.at_xpath("xmlns:data[@id=\"#{ds.id}\"]")
        ds.id.should == data.attributes["id"].value
        if (tags = data.xpath("xmlns:tag").collect { |t| t.content.strip }).any?
          ds.tags.should == tags.sort{ |a,b| a.downcase <=> b.downcase }.join(',')
        end
        current_value = data.at_xpath("xmlns:value")
        ds.current_value.should == current_value.content
        ds.min_value.should == current_value.attributes["minValue"].value
        ds.max_value.should == current_value.attributes["maxValue"].value
        unit = data.at_xpath("xmlns:unit")
        if unit
          ds.unit_label.should == unit.content
          ds.unit_type.should == unit.attributes["type"].value if unit.attributes["type"]
          ds.unit_symbol.should == unit.attributes["symbol"].value if unit.attributes["symbol"]
        end
      end
      true
    else
      false
    end
  end

  def match_json_feed(feed, formatted_feed)
    json = MultiJson.load(formatted_feed)
    case json['version']
    when '1.0.0'
      feed.title.should == json["title"]
      feed.status.should == json["status"]
      feed.creator.should == json["creator"]
      feed.updated.should == json["updated"]
      feed.created.should == json["created"]
      feed.website.should == json["website"]
      feed.private.should == json["private"]
      feed.feed.should == json["feed"]
      feed.auto_feed_url.should == json["auto_feed_url"]
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
        datastream.datapoints.each do |datapoint|
          dp = ds['datapoints'].detect{|s| s["at"] == datapoint.at}
          datapoint.value.should == dp["value"]
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
      feed.owner_login.should == json["user"]["login"]
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


