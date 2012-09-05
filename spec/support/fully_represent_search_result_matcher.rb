RSpec::Matchers.define :fully_represent_search_result do |format, formatted_search_result|
  match do |search_result|
    match_json_search_result(search_result, formatted_search_result)
  end

  failure_message_for_should do |search_result|
    "expected #{search_result} to fully represent #{formatted_search_result}"
  end

  description do
    "expected #{formatted_search_result.class} to be fully represented"
  end

  def match_json_search_result(search_result, formatted_search_result)
    json = MultiJson.load(formatted_search_result)
    search_result.totalResults.should == json['totalResults']
    search_result.startIndex.should == json['startIndex']
    search_result.itemsPerPage.should == json['itemsPerPage']
    json = json['results'].first
    feed = search_result.results.first
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
    else
      false
    end
  end

end


