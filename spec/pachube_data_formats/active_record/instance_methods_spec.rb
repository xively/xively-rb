require File.dirname(__FILE__) + '/../../spec_helper'

describe PachubeDataFormats::ActiveRecord::InstanceMethods do
  load_schema
  before(:each) do
    @owner = Owner.create(
      :login => "fred",
      :email => "fred@example.com"
    )
    @feed = Feed.create!(
      {
        "retrieved_at" => Time.parse("20110202"),
        "title" => "Feed Title",
        "csv_version" => "v2",
        "private" => true,
        "icon" => "http://pachube.com/logo.png",
        "website" => "http://pachube.com",
        "tag_list" => "kittens, sofa, aardvark",
        "description" => "Test feed",
        "feed" => "http://test.host/testfeed.html?random=890299&rand2=91",
        "email" => "abc@example.com",
        "owner" => @owner
      })
    @datastream1 = @feed.datastreams.create!(datastream_as_(:hash))
    @datastream2 = @feed.datastreams.create!(datastream_as_(:hash))
  end

  describe "#as_pachube_json" do
    it "should return full Pachube JSON hash with associated datastreams" do
      json = @feed.as_pachube_json
      json["version"].should == "1.0.0"
      json["title"].should == "Feed Title"
      json["private"].should == true
      json["icon"].should == "http://pachube.com/logo.png"
      json["website"].should == "http://pachube.com"
      json["tags"].should == ["aardvark", "kittens", "sofa"]
      json["description"].should == "Test feed"
      json["feed"].should == "http://test.host/testfeed.html?random=890299&rand2=91"
      json["email"].should == "abc@example.com"
      json["datastreams"].should have(2).things
      json["datastreams"].each do |ds|
        ds["max_value"].should == 658.0
        ds["min_value"].should == 0.0
        ds["current_value"].should == "14"
        @feed.datastreams.find(ds["id"]).should_not be_nil
        ds["tags"].should == ["freakin lasers", "humidity", "temperature"]
      end
    end

    it "should optionally return full Pachube v1 0.6-alpha json with associated datastreams" do
      json = @feed.as_pachube_json("0.6-alpha")
      json["version"].should == "0.6-alpha"
      json["title"].should == "Feed Title"
      json["private"].should be_nil
      json["icon"].should == "http://pachube.com/logo.png"
      json["website"].should == "http://pachube.com"
      json["tags"].should be_nil
      json["description"].should == "Test feed"
      json["feed"].should == "http://test.host/testfeed.html?random=890299&rand2=91"
      json["email"].should == "abc@example.com"
      json["datastreams"].should have(2).things
      json["datastreams"].each do |ds|
        ds["values"].first["max_value"].should == 658.0
        ds["values"].first["min_value"].should == 0.0
        ds["values"].first["value"].should == "14"
        ds["values"].first["recorded_at"].should == Time.parse("2011/01/02 00:00:00 +0000").iso8601
        @feed.datastreams.find(ds["id"]).should_not be_nil
        ds["tags"].should == ["freakin lasers", "humidity", "temperature"]
      end
    end
  end

  describe "#to_pachube_json" do
    it "should return Pachube json based on the object's attributes" do
      PachubeDataFormats::Feed.should_receive(:new).with(hash_including(@feed.attributes)).and_return(:feed => "json representation of a feed")
      @feed.to_pachube_json.should == {:feed => "json representation of a feed"}.to_json
    end

    it "should return full Pachube JSON with associated datastreams" do
      json = JSON.parse(@feed.to_pachube_json)
      json["version"].should == "1.0.0"
      json["title"].should == "Feed Title"
      json["private"].should == true
      json["icon"].should == "http://pachube.com/logo.png"
      json["website"].should == "http://pachube.com"
      json["tags"].should == ["aardvark", "kittens", "sofa"]
      json["description"].should == "Test feed"
      json["feed"].should == "http://test.host/testfeed.html?random=890299&rand2=91"
      json["email"].should == "abc@example.com"
      json["datastreams"].should have(2).things
      json["datastreams"].each do |ds|
        ds["max_value"].should == 658.0
        ds["min_value"].should == 0.0
        ds["current_value"].should == "14"
        @feed.datastreams.find(ds["id"]).should_not be_nil
        ds["tags"].should == ["freakin lasers", "humidity", "temperature"]
      end
    end

    it "should optionally return full Pachube v1 0.6-alpha JSON with associated datastreams" do
      json = JSON.parse(@feed.to_pachube_json("0.6-alpha"))
      json["version"].should == "0.6-alpha"
      json["title"].should == "Feed Title"
      json["private"].should be_nil
      json["icon"].should == "http://pachube.com/logo.png"
      json["website"].should == "http://pachube.com"
      json["tags"].should be_nil
      json["description"].should == "Test feed"
      json["feed"].should == "http://test.host/testfeed.html?random=890299&rand2=91"
      json["email"].should == "abc@example.com"
      json["datastreams"].should have(2).things
      json["datastreams"].each do |ds|
        ds["values"].first["max_value"].should == 658.0
        ds["values"].first["min_value"].should == 0.0
        ds["values"].first["value"].should == "14"
        ds["values"].first["recorded_at"].should == Time.parse("2011/01/02 00:00:00 +0000").iso8601
        @feed.datastreams.find(ds["id"]).should_not be_nil
        ds["tags"].should == ["freakin lasers", "humidity", "temperature"]
      end
    end
  end

end
