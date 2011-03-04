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
        "creator" => "http://www.pachube.com",
        "location_name" => "London",
        "location_disposition" => "fixed",
        "location_domain" => "here",
        "location_ele" => "2000",
        "location_exposure" => "naked",
        "location_lat" => 51.5423,
        "location_lon" => 3.243
      })
    @datastream1 = @feed.datastreams.create!(datastream_as_(:hash, :with => {"stream_id" => "0"}, :except => ["datapoints"]))
    @datastream2 = @feed.datastreams.create!(datastream_as_(:hash, :with => {"stream_id" => "two"}, :except => ["datapoints"]))
    10.times {@datastream2.datapoints.create!(:value => "#{rand(10000)}", :at => rand(10000).minutes.ago)}
  end

  describe "#to_pachube" do
    it "should return the appropriate PachubeDataFormats Object" do
      @feed.to_pachube.should be_kind_of(PachubeDataFormats::Feed)
      @datastream1.to_pachube.should be_kind_of(PachubeDataFormats::Datastream)
      @datastream2.datapoints.first.to_pachube.should be_kind_of(PachubeDataFormats::Datapoint)
    end

    context "Feed" do
      it "should map the default fields by default" do
        PachubeDataFormats::Feed.should_receive(:new).with(@feed.attributes)
        @feed.to_pachube
      end
    end

    context "Datastream" do
      it "should map the default fields merged with the optionals by default" do
        PachubeDataFormats::Datastream.should_receive(:new).with(@datastream2.attributes.merge({"id" => "two"}))
        @datastream2.to_pachube
      end
    end

    context "Datapoint" do
      it "should map the default fields by default" do
        PachubeDataFormats::Datapoint.should_receive(:new).with(@datastream2.datapoints.first.attributes)
        @datastream2.datapoints.first.to_pachube
      end
    end
  end

  context "custom mappings" do
    it "should allow custom method mappings" do
      class CustomFeed < ActiveRecord::Base
        set_table_name :feeds
        has_many :datastreams, :foreign_key => :feed_id
        is_pachube_data_format :feed, {:feed => :custom_method}
        def custom_method
          "I haz customer"
        end
      end
      feed = CustomFeed.create!(:title => "Name")
      PachubeDataFormats::Feed.should_receive(:new).with(feed.attributes.merge({"feed" => feed.custom_method}))
      feed.to_pachube
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
      feed.to_pachube
    end
  end
end

