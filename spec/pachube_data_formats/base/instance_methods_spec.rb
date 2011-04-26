require File.dirname(__FILE__) + '/../../spec_helper'

describe PachubeDataFormats::Base::InstanceMethods do
  before(:each) do
    @feed = Feed.new
    @feed.updated = Time.parse("20110202")
    @feed.title = "Feed Title"
    @feed.private = true
    @feed.icon = "http://pachube.com/logo.png"
    @feed.website = "http://pachube.com"
    @feed.tags = "kittens, sofa, aardvark"
    @feed.description = "Test feed"
    @feed.feed = "http://test.host/testfeed.html?random=890299&rand2=91"
    @feed.email = "abc@example.com"
    @feed.creator = "http://www.pachube.com"
    @feed.location_name = "London"
    @feed.location_disposition = "fixed"
    @feed.location_domain = "here"
    @feed.location_ele = "2000"
    @feed.location_exposure = "naked"
    @feed.location_lat = 51.5423
    @feed.location_lon = 3.243
    @datastream1 = Datastream.new
    datastream_as_(:hash, :with => {"stream_id" => "0"}, :except => ["datapoints"]).each do |k,v|
      @datastream1.send("#{k}=", v)
    end
    #  @feed.datastreams.create!(datastream_as_(:hash, :with => {"stream_id" => "0"}, :except => ["datapoints"]))
    @datastream2 = Datastream.new
    datastream_as_(:hash, :with => {"stream_id" => "two"}, :except => ["datapoints"]).each do |k,v|
      @datastream2.send("#{k}=", v)
    end
    @feed.datastreams = [@datastream1, @datastream2]
    datapoints = []
    10.times do
      datapoint = Datapoint.new
      datapoint.value = "#{rand(10000)}"
      datapoint.at = Time.now - rand(10000) * 60
      datapoints << datapoint
    end
    @datastream2.datapoints = datapoints
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
      class CustomFeed
        extend PachubeDataFormats::Base

        undef_method :id
        attr_accessor :title
        is_pachube_data_format :feed, {:feed => :custom_method}

        def custom_method
          "I haz customer"
        end
      end
      feed = CustomFeed.new
      feed.title = "Name"
      PachubeDataFormats::Feed.should_receive(:new).with({"feed" => feed.custom_method, "title" => feed.title})
      feed.to_pachube
    end

    it "should not rely on datastreams using this gem" do
      class NewCustomFeed
        extend PachubeDataFormats::Base

        attr_accessor :title
        is_pachube_data_format :feed

        def datastreams
          ["fake datastream"]
        end
      end

      feed = NewCustomFeed.new
      feed.title = "Name"
      feed.to_pachube
    end
  end
end

