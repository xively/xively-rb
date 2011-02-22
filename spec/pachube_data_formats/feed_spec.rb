require File.dirname(__FILE__) + '/../spec_helper'

describe PachubeDataFormats::Feed do

  it "should have a constant that defines the allowed keys" do
    PachubeDataFormats::Feed::ALLOWED_KEYS.should == %w(created_at csv_version datastreams description email feed icon id location private retrieved_at status tag_list title updated_at website)
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
        PachubeDataFormats::Formats::Feeds::JSON.should_receive(:parse).with(feed_as_(:json)).and_return({"title" => "Environment"})
        feed = PachubeDataFormats::Feed.new(feed_as_(:json))
        feed.title.should == "Environment"
      end
    end

    context "input from hash" do
      it "should use the PachubeHash parser and store the outcome" do
        PachubeDataFormats::Formats::Feeds::Hash.should_receive(:parse).with(feed_as_(:hash)).and_return({"title" => "Environment"})
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
      attrs["datastreams"] = [PachubeDataFormats::Datastream.new({"id" => "ein"})]
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

  context "associated datastreams" do

    describe "#datastreams" do
      it "should return an array of datastreams" do
        datastreams = [PachubeDataFormats::Datastream.new(datastream_as_(:hash))]
        attrs = {"datastreams" => datastreams}
        feed = PachubeDataFormats::Feed.new(attrs)
        feed.datastreams.each do |ds|
          ds.should be_kind_of(PachubeDataFormats::Datastream)
        end
      end
    end

    describe "#datastreams=" do
      before(:each) do
        @feed = PachubeDataFormats::Feed.new({})
      end

      it "should return nil if not an array" do
        @feed.datastreams = "kittens"
        @feed.datastreams.should be_nil
      end

      it "should accept an array of datastreams and hashes and store an array of datastreams" do
        new_datastream1 = PachubeDataFormats::Datastream.new(datastream_as_(:hash))
        new_datastream2 = PachubeDataFormats::Datastream.new(datastream_as_(:hash))
        PachubeDataFormats::Datastream.should_receive(:new).with(datastream_as_(:hash)).and_return(new_datastream2)

        datastreams = [new_datastream1, datastream_as_(:hash)]
        @feed.datastreams = datastreams
        @feed.datastreams.length.should == 2
        @feed.datastreams.should include(new_datastream1)
        @feed.datastreams.should include(new_datastream2)
      end

      it "should accept an array of datastreams and store an array of datastreams" do
        datastreams = [PachubeDataFormats::Datastream.new(datastream_as_(:hash))]
        @feed.datastreams = datastreams
        @feed.datastreams.should == datastreams
      end

      it "should accept an array of hashes and store an array of datastreams" do
        new_datastream = PachubeDataFormats::Datastream.new(datastream_as_(:hash))
        PachubeDataFormats::Datastream.should_receive(:new).with(datastream_as_(:hash)).and_return(new_datastream)

        datastreams_hash = [datastream_as_(:hash)]
        @feed.datastreams = datastreams_hash
        @feed.datastreams.should == [new_datastream]
      end
    end

  end

  describe "#to_json" do
    it "should use the PachubeJSON generator" do
      feed_hash = {"title" => "Environment"}
      feed = PachubeDataFormats::Feed.new(feed_hash)
      PachubeDataFormats::Formats::Feeds::JSON.should_receive(:generate).with(hash_including(feed_hash)).and_return({"title" => "Environment"})
      feed.to_json.should == {"title" => "Environment"}.to_json
    end

    it "should append the json version" do
      version = "1.0.0"
      feed_hash = {"title" => "Environment"}
      feed = PachubeDataFormats::Feed.new(feed_hash)
      feed.to_json.should == {"title" => "Environment", "version" => version}.to_json
    end

    it "should accept optional json version" do
      version = "0.6-alpha"
      feed_hash = {"title" => "Environment"}
      feed = PachubeDataFormats::Feed.new(feed_hash)
      feed.to_json(:version => version).should == {"title" => "Environment", "version" => version}.to_json
    end

    it "should use the PachubeJSON generator for datastreams" do
      feed = PachubeDataFormats::Feed.new(feed_as_('hash'))
      feed.datastreams = datastream_as_(:hash)
      feed.datastreams.each do |ds|
        ds.should_receive(:to_json).and_return("{\"stream_id\":\"#{ds.id}\"}")
      end
      parsed_datastreams = JSON.parse(feed.to_json)["datastreams"]
      feed.datastreams.each do |ds|
        parsed_datastreams.should include({"stream_id" => ds.id})
      end
    end

  end

  describe "#to_hash" do
    it "should use the PachubeHash generator" do
      feed_hash = {"title" => "Environment"}
      feed = PachubeDataFormats::Feed.new(feed_hash)
      PachubeDataFormats::Formats::Feeds::Hash.should_receive(:generate).with(feed_hash).and_return({"title" => "Environment"})
      feed.to_hash.should == {"title" => "Environment"}
    end

    it "should use the PachubeHash generator for datastreams" do
      feed = PachubeDataFormats::Feed.new(feed_as_(:hash))
      feed.datastreams = datastream_as_(:hash)
      feed.datastreams.each do |ds|
        ds.should_receive(:to_hash).and_return({"stream_id" => "#{ds.id}"})
      end
      datastreams = feed.to_hash["datastreams"]
      feed.datastreams.each do |ds|
        datastreams.should include({"stream_id" => ds.id})
      end
    end

  end
end
