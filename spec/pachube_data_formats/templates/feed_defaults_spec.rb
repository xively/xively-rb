require File.dirname(__FILE__) + '/../../spec_helper'

describe "default feed templates" do
  before(:each) do
    @feed = PachubeDataFormats::Feed.new(feed_as_(:hash))
  end

  describe "json" do
    it "should default to 1.0.0" do
      @feed.generate_json("1.0.0").should == @feed.as_json
    end

    it "should represent Pachube JSON 1.0.0 (used by API v2)" do
      json = @feed.generate_json("1.0.0")
      json["version"].should == "1.0.0"
      json["title"].should == "Pachube Office Environment"
      json["private"].should == false
      json["icon"].should == "http://pachube.com/logo.png"
      json["website"].should == "http://pachube.com"
      json["tags"].should == ["aardvark", "kittens", "sofa"]
      json["description"].should == "Sensors in Pachube.com's headquarters."
      json["feed"].should == "http://test.host/testfeed.html?random=890299&rand2=91"
      json["status"].should == "live"
      json["updated"].should == "2011-01-02T00:00:00.000000+00:00"
      json["email"].should == "abc@example.com"
      json["datastreams"].should have(7).things
      json["datastreams"].each do |ds|
        datastream = @feed.datastreams.detect{|stream| stream.stream_id == ds["id"]}
        ds["at"].should == datastream.retrieved_at.iso8601(6)
        ds["max_value"].should == datastream.max_value
        ds["min_value"].should == datastream.min_value
        ds["current_value"].should == datastream.value
        ds["tags"].should == datastream.tag_list.split(',').map(&:strip).sort
      end
    end

    it "should represent Pachube JSON 0.6-alpha (used by API v1)" do
      json = @feed.generate_json("0.6-alpha")
      json["version"].should == "0.6-alpha"
      json["title"].should == "Pachube Office Environment"
      json["private"].should be_nil
      json["icon"].should == "http://pachube.com/logo.png"
      json["website"].should == "http://pachube.com"
      json["tags"].should be_nil
      json["description"].should == "Sensors in Pachube.com's headquarters."
      json["feed"].should == "http://test.host/testfeed.html?random=890299&rand2=91"
      json["status"].should == "live"
      json["updated"].should == "2011-01-02T00:00:00.000000+00:00"
      json["email"].should == "abc@example.com"
      json["datastreams"].should have(7).things
      json["datastreams"].each do |ds|
        datastream = @feed.datastreams.detect{|stream| stream.stream_id == ds["id"]}
        ds["values"].first["max_value"].should == datastream.max_value
        ds["values"].first["min_value"].should == datastream.min_value
        ds["values"].first["value"].should == datastream.value
        ds["values"].first["recorded_at"].should == datastream.retrieved_at.iso8601
        ds["tags"].should == datastream.tag_list.split(',').map(&:strip).sort
      end
    end
  end
end

