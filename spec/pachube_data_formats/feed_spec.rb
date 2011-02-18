require File.dirname(__FILE__) + '/../spec_helper'

describe PachubeDataFormats::Feed do

  it "should have a constant that defines the allowed keys" do
    PachubeDataFormats::Feed::ALLOWED_KEYS.should == %w(created_at csv_version datastreams description email feed icon id location owner private retrieved_at status tags title updated_at website)
  end


  context "attr accessors" do
    before(:each) do
      @feed = PachubeDataFormats::Feed.new(feed_as_(:json))
    end

    describe "setting whitelisted fields" do
      PachubeDataFormats::Feed::ALLOWED_KEYS.each do |key|
        it "##{key}=" do
          lambda {
            @feed.send("#{key}=", key)
          }.should_not raise_error
        end
      end
    end

    describe "getting whitelisted fields" do
      PachubeDataFormats::Feed::ALLOWED_KEYS.each do |key|
        it "##{key}" do
          lambda {
            @feed.send(key)
          }.should_not raise_error
        end
      end
    end

    describe "setting non-whitelisted keys" do
      it "should not be possible to set non-whitelisted fields" do
        lambda {
          @feed.something_bogus = 'whatevs'
        }.should raise_error
      end

      it "should not be possible to get non-whitelisted fields" do
        lambda {
          @feed.something_bogus
        }.should raise_error
      end
    end
  end

  describe "#initialize" do
    it "should require one parameter" do
      lambda{PachubeDataFormats::Feed.new}.should raise_exception(ArgumentError, "wrong number of arguments (0 for 1)")
    end

    context "input from json" do
      it "should use the PachubeJSON parser and store the outcome" do
        PachubeDataFormats::FeedFormats::PachubeJSON.should_receive(:parse).with(feed_as_(:json)).and_return({"title" => "Environment"})
        feed = PachubeDataFormats::Feed.new(feed_as_(:json))
        feed.title.should == "Environment"
      end
    end

    context "input from hash" do
      it "should use the PachubeHash parser and store the outcome" do
        PachubeDataFormats::FeedFormats::PachubeHash.should_receive(:parse).with(feed_as_(:hash)).and_return({"title" => "Environment"})
        feed = PachubeDataFormats::Feed.new(feed_as_(:hash))
        feed.title.should == "Environment"
      end
    end
  end

  describe "#attributes" do
    it "should return a hash of feed properties" do
      attrs = {}
      PachubeDataFormats::Feed::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      feed = PachubeDataFormats::Feed.new(attrs)

      feed.attributes.should == attrs
    end

    it "should not return nil values" do
      attrs = {}
      PachubeDataFormats::Feed::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["created_at"] = nil
      feed = PachubeDataFormats::Feed.new(attrs)

      feed.attributes.should_not include("created_at")
    end
  end

  describe "#attributes=" do
    it "should accept and save a hash of feed properties" do
      feed = PachubeDataFormats::Feed.new({})

      attrs = {}
      PachubeDataFormats::Feed::ALLOWED_KEYS.each do |key|
        value = "key #{rand(1000)}"
        attrs[key] = value
        feed.should_receive("#{key}=").with(value)
      end
      feed.attributes=(attrs)
    end
  end

  describe "#datastreams" do
    it "should return an array of datastreams" do
      datastreams = [PachubeDataFormats::Datastream.new(datastream_as_(:hash))]
      attrs = {"datastreams" => datastreams}
      feed = PachubeDataFormats::Feed.new(attrs)
      feed.datastreams.should == datastreams
    end
  end

  describe "#datastreams=" do
    it "should accept and store an array of datastreams"
  end

  describe "#to_json" do
    it "should use the PachubeJSON generator" do
      feed = PachubeDataFormats::Feed.new(feed_as_('hash'))
      PachubeDataFormats::FeedFormats::PachubeJSON.should_receive(:generate).with(feed_as_(:hash)).and_return({"title" => "Environment"})
      feed.to_json.should == {"title" => "Environment"}
    end
  end

  describe "#to_hash" do
    it "should use the PachubeHash generator" do
      feed = PachubeDataFormats::Feed.new(feed_as_('hash'))
      PachubeDataFormats::FeedFormats::PachubeHash.should_receive(:generate).with(feed_as_(:hash)).and_return({"title" => "Environment"})
      feed.to_hash.should == {"title" => "Environment"}
    end
  end
end
