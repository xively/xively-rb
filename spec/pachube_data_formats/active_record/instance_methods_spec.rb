require File.dirname(__FILE__) + '/../../spec_helper'

describe PachubeDataFormats::ActiveRecord::InstanceMethods do
  load_schema
  before(:each) do
    @owner = Owner.create(
      :login => "fred",
      :email => "fred@example.com"
    )
  end

  describe "#to_pachube_json" do
    it "should return Pachube json based on the object's attributes" do
      feed = Feed.create!(:title => "Pachube Feed", :description => "Stuff", :website => "http://pachube.com", :tag_list => "alpha, beta, aardvark, kittens", :owner => @owner)
      PachubeDataFormats::Feed.should_receive(:new).with(hash_including(feed.attributes)).and_return(:feed => "json representation of a feed")
      feed.to_pachube_json.should == {:feed => "json representation of a feed"}.to_json
    end

    it "should return full Pachube json with associated datastreams" do
      feed = Feed.create!(
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
      datastream1 = feed.datastreams.create!(datastream_as_(:hash))
      datastream2 = feed.datastreams.create!(datastream_as_(:hash))
      json = JSON.parse(feed.to_pachube_json)
      json["version"].should == "1.0.0"
      json["title"].should == "Feed Title"
      json["csv_version"].should == "v2"
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
        feed.datastreams.find(ds["id"]).should_not be_nil
        ds["tags"].should == ["freakin lasers", "humidity", "temperature"]
      end
    end

  end

end
