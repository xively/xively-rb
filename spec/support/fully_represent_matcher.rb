RSpec::Matchers.define :fully_represent do |pdf_formatted|
  match do |pdf_object|
    json = JSON.parse(pdf_formatted)
    feed = pdf_object
    case json['version']
    when '1.0.0'
      feed.title.should == json["title"]
      feed.state.should == json["status"]
      feed.retrieved_at.should == json["updated"]
      feed.website.should == json["website"]
      feed.private.should == json["private"]
      feed.feed.should == json["feed"]
      no_units = true
      feed.datastreams.should_not be_empty
      feed.datastreams.each do |datastream|
        ds = json['datastreams'].detect{|s| s["id"] == datastream.stream_id}
        datastream.value.should == ds["current_value"]
        datastream.min_value.should == ds["min_value"]
        datastream.max_value.should == ds["max_value"]
        datastream.retrieved_at.should == ds["at"]
        datastream.tag_list.should == ds["tags"].join(',')
        if ds["unit"]
          no_units = false
          datastream.unit_label.should == ds["unit"]["label"]
          datastream.unit_symbol.should == ds["unit"]["symbol"]
          datastream.unit_type.should == ds["unit"]["type"]
        end
      end
      raise "This test is testing a feed with no datastream units" if no_units
      feed.id.should == json["id"]
      feed.location.should == json["location"]
    when '0.6-alpha'
      feed.title.should == json["title"]
      feed.state.should == json["status"]
      feed.retrieved_at.should == json["updated"]
      feed.website.should == json["website"]
      feed.private.should be_nil
      feed.feed.should == json["feed"]
      no_units = true
      feed.datastreams.should_not be_empty
      feed.datastreams.each do |datastream|
        ds = json['datastreams'].detect{|s| s["id"] == datastream.stream_id}
        datastream.value.should == ds["values"].first["value"]
        datastream.min_value.should == ds["values"].first["min_value"]
        datastream.max_value.should == ds["values"].first["max_value"]
        datastream.retrieved_at.should == ds["values"].first["recorded_at"]
        datastream.tag_list.should == ds["tags"].join(',')
        if ds["unit"]
          no_units = false
          datastream.unit_label.should == ds["unit"]["label"]
          datastream.unit_symbol.should == ds["unit"]["symbol"]
          datastream.unit_type.should == ds["unit"]["type"]
        end
      end
      raise "This test is testing a feed with no datastream units" if no_units
      feed.id.should == json["id"]
      feed.location.should == json["location"]
    else
      false
    end
  end

  failure_message_for_should do |pdf_object|
    "expected #{pdf_object} to fully represent #{pdf_formatted}"
  end

  description do
    "expected #{pdf_formatted.class} to be fully represented"
  end
end


