require 'spec_helper'

describe Cosm::Base::InstanceMethods do
  before(:each) do
    @feed = Feed.new
    @feed.updated = Time.parse("20110202")
    @feed.title = "Feed Title"
    @feed.private = true
    @feed.icon = "http://cosm.com/logo.png"
    @feed.website = "http://cosm.com"
    @feed.tags = "kittens, sofa, aardvark"
    @feed.description = "Test feed"
    @feed.feed = "http://test.host/testfeed.html?random=890299&rand2=91"
    @feed.email = "abc@example.com"
    @feed.creator = "http://www.cosm.com"
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

  describe "#to_cosm" do
    it "should return the appropriate Cosm Object" do
      @feed.to_cosm.should be_kind_of(Cosm::Feed)
      @datastream1.to_cosm.should be_kind_of(Cosm::Datastream)
      @datastream2.datapoints.first.to_cosm.should be_kind_of(Cosm::Datapoint)
    end

    context "Feed" do
      it "should map the default fields by default" do
        Cosm::Feed.should_receive(:new).with(@feed.attributes)
        @feed.to_cosm
      end
    end

    context "Datastream" do
      it "should map the default fields merged with the optionals by default" do
        Cosm::Datastream.should_receive(:new).with(@datastream2.attributes.merge({"id" => "two"}))
        @datastream2.to_cosm
      end
    end

    context "Datapoint" do
      it "should map the default fields by default" do
        Cosm::Datapoint.should_receive(:new).with(@datastream2.datapoints.first.attributes)
        @datastream2.datapoints.first.to_cosm
      end
    end
  end

  context "custom mappings" do
    it "should allow custom method mappings" do
      class CustomFeed
        extend Cosm::Base

        undef_method :id if method_defined?(:id)
        attr_accessor :title
        is_cosm :feed, {:feed => :custom_method}

        def custom_method
          "I haz customer"
        end
      end
      feed = CustomFeed.new
      feed.title = "Name"
      Cosm::Feed.should_receive(:new).with({"feed" => feed.custom_method, "title" => feed.title})
      feed.to_cosm
    end

    it "should not rely on datastreams using this gem" do
      class NewCustomFeed
        extend Cosm::Base

        attr_accessor :title
        is_cosm :feed

        def datastreams
          ["fake datastream"]
        end
      end

      feed = NewCustomFeed.new
      feed.title = "Name"
      feed.to_cosm
    end
  end
end

