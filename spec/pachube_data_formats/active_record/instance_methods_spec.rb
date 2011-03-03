require File.dirname(__FILE__) + '/../../spec_helper'

describe PachubeDataFormats::ActiveRecord::InstanceMethods do
  load_schema
  before(:each) do
    @feed = Feed.create!(
      {
        "updated" => Time.parse("20110202"),
        "title" => "Feed Title",
        "private" => true,
        "icon" => "http://pachube.com/logo.png",
        "website" => "http://pachube.com",
        "tags" => "kittens, sofa, aardvark",
        "description" => "Test feed",
        "feed" => "http://test.host/testfeed.html?random=890299&rand2=91",
        "email" => "abc@example.com",
        "creator" => "http://www.pachube.com"
      })
    @datastream1 = @feed.datastreams.create!(datastream_as_(:hash, :with => {"stream_id" => "0"}, :except => ["datapoints"]))
    @datastream2 = @feed.datastreams.create!(datastream_as_(:hash, :with => {"stream_id" => "two"}, :except => ["datapoints"]))
    10.times {@datastream2.datapoints.create!(:value => "#{rand(10000)}", :at => rand(10000).minutes.ago)}
  end

  it "should allow mapping of datastreams" do
    PachubeDataFormats::Datastream.should_receive(:new).with(@datastream2.attributes.merge("id" => "two"))
    @datastream2.send(:new_object)
  end

  context "custom mappings" do
    it "should create feed with attributes including datastreams by default" do
      PachubeDataFormats::Feed.should_receive(:new).with(@feed.attributes.merge("datastreams" => @feed.datastreams.map{|ds|ds.attributes.merge(ds.send(:custom_pachube_attributes))}))
      @feed.send(:new_object)
    end

    it "should allow custom mappings" do
      class CustomFeed < ActiveRecord::Base
        set_table_name :feeds
        has_many :datastreams, :foreign_key => :feed_id
        is_pachube_data_format :feed, {:feed => :custom_method}
        def custom_method
          "I haz customer"
        end
      end
      feed = CustomFeed.create!(:title => "Name")
      PachubeDataFormats::Feed.should_receive(:new).with(feed.attributes.merge({"datastreams" => feed.datastreams.map(&:attributes), "feed" => feed.custom_method}))
      feed.send(:new_object)
    end

    it "should not rely on datastreams using this gem" do
      class NewCustomFeed < ActiveRecord::Base
        set_table_name :feeds
        is_pachube_data_format :feed

        def datastreams
          ["fake datastream"]
        end
      end

      feed = NewCustomFeed.create!(:title => "Name")
      feed.as_pachube_json
    end
  end

  describe "#to_pachube_xml" do
    it "should accept an optional version" do
      feed = PachubeDataFormats::Feed.new({})
      feed.should_receive(:to_xml).with(:version => "5").and_return("xml")
      PachubeDataFormats::Feed.should_receive(:new).with(@feed.send(:attributes_with_associations)).and_return(feed)
      @feed.to_pachube_xml("5").should == "xml"
    end

    it "should allow optional datapoints" do
      xml = Nokogiri.parse(@feed.to_pachube_xml("0.5.1", :include => :datapoints))
      xml.xpath("//xmlns:datapoints").should_not be_empty
    end

    it "should allow disabling datastreams" do
      xml = Nokogiri.parse(@feed.to_pachube_xml("0.5.1", :exclude => :datastreams))
      xml.xpath("//xmlns:data").should be_empty
    end

    it "should return the appropriate xml representation of a feed by default" do
      feed = PachubeDataFormats::Feed.new({})
      feed.stub(:to_xml).and_return("xml")
      PachubeDataFormats::Feed.should_receive(:new).with(@feed.send(:attributes_with_associations)).and_return(feed)
      @feed.to_pachube_xml.should == "xml"
    end

    it "should return the appropriate xml representation of a datastream" do
      datastream = PachubeDataFormats::Datastream.new({})
      datastream.stub(:to_xml).and_return("xml")
      PachubeDataFormats::Datastream.should_receive(:new).with(@datastream2.send(:attributes_with_associations)).and_return(datastream)
      @datastream2.to_pachube_xml.should == "xml"
    end
  end

  describe "#as_pachube_json" do

    it "should allow disabling datastreams" do
      json = @feed.as_pachube_json("1.0.0", :exclude => :datastreams)
      json[:datastreams].should be_nil
    end

    it "should allow optional datapoints" do
      json = @feed.as_pachube_json("1.0.0", :include => :datapoints)
      json[:datastreams].detect{|json| json[:id] == "two"}[:datapoints].should_not be_nil
    end

    it "should return full Pachube JSON hash with associated datastreams" do
      json = @feed.as_pachube_json
      json[:version].should == "1.0.0"
      json[:title].should == "Feed Title"
      json[:private].should == true
      json[:icon].should == "http://pachube.com/logo.png"
      json[:website].should == "http://pachube.com"
      json[:tags].should == ["aardvark", "kittens", "sofa"]
      json[:description].should == "Test feed"
      json[:feed].should == "http://test.host/testfeed.html?random=890299&rand2=91.json"
      json[:email].should == "abc@example.com"
      json[:datastreams].should have(2).things
      json[:datastreams].each do |ds|
        ds[:max_value].should == 658.0
        ds[:min_value].should == 0.0
        ds[:current_value].should == "14"
        ds[:at].should == "2011-01-02T00:00:00.000000+00:00"
        @feed.datastreams.find_by_stream_id(ds[:id]).should_not be_nil
        ds[:tags].should == ["freakin lasers", "humidity", "Temperature"]
      end
    end

    it "should optionally return full Pachube v1 0.6-alpha json with associated datastreams" do
      json = @feed.as_pachube_json("0.6-alpha")
      json[:version].should == "0.6-alpha"
      json[:title].should == "Feed Title"
      json[:private].should be_nil
      json[:icon].should == "http://pachube.com/logo.png"
      json[:website].should == "http://pachube.com"
      json[:tags].should be_nil
      json[:description].should == "Test feed"
      json[:feed].should == "http://test.host/testfeed.html?random=890299&rand2=91.json"
      json[:email].should == "abc@example.com"
      json[:datastreams].should have(2).things
      json[:datastreams].each do |ds|
        ds[:values].first[:max_value].should == 658.0
        ds[:values].first[:min_value].should == 0.0
        ds[:values].first[:value].should == "14"
        ds[:values].first[:recorded_at].should == Time.parse("2011/01/02 00:00:00 +0000").iso8601
        @feed.datastreams.find_by_stream_id(ds[:id]).should_not be_nil
        ds[:tags].should == ["freakin lasers", "humidity", "Temperature"]
      end
    end
  end

  describe "#to_pachube_json" do

    it "should allow disabling datastreams" do
      json = JSON.parse(@feed.to_pachube_json("1.0.0", :exclude => :datastreams))
      json["datastreams"].should be_nil
    end

    it "should allow optional datapoints" do
      json = JSON.parse(@feed.to_pachube_json("1.0.0", :include => :datapoints))
      json["datastreams"].detect{|json| json["id"] == "two"}["datapoints"].should_not be_nil
    end

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
      json["feed"].should == "http://test.host/testfeed.html?random=890299&rand2=91.json"
      json["email"].should == "abc@example.com"
      json["datastreams"].should have(2).things
      json["datastreams"].each do |ds|
        ds["max_value"].should == 658.0
        ds["min_value"].should == 0.0
        ds["current_value"].should == "14"
        @feed.datastreams.find_by_stream_id(ds["id"]).should_not be_nil
        ds["tags"].should == ["freakin lasers", "humidity", "Temperature"]
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
      json["feed"].should == "http://test.host/testfeed.html?random=890299&rand2=91.json"
      json["email"].should == "abc@example.com"
      json["datastreams"].should have(2).things
      json["datastreams"].each do |ds|
        ds["values"].first["max_value"].should == 658.0
        ds["values"].first["min_value"].should == 0.0
        ds["values"].first["value"].should == "14"
        ds["values"].first["recorded_at"].should == Time.parse("2011/01/02 00:00:00 +0000").iso8601
        @feed.datastreams.find_by_stream_id(ds["id"]).should_not be_nil
        ds["tags"].should == ["freakin lasers", "humidity", "Temperature"]
      end
    end
  end

end
