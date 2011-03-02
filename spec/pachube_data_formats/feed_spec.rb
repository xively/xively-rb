require File.dirname(__FILE__) + '/../spec_helper'

describe PachubeDataFormats::Feed do

  it "should have a constant that defines the allowed keys" do
    PachubeDataFormats::Feed::ALLOWED_KEYS.should == %w(creator datastreams description email feed icon id location_disposition location_domain location_ele location_exposure location_lat location_lon location_name private status tags title updated website)
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

    it "should accept json" do
      feed = PachubeDataFormats::Feed.new(feed_as_(:json))
      feed.title.should == "Pachube Office Environment"
    end

    it "should accept a hash of attributes" do
      feed = PachubeDataFormats::Feed.new(feed_as_(:hash))
      feed.title.should == "Pachube Office Environment"
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

  # Provided by PachubeDataFormats::Templates::FeedDefaults
  describe "#generate_json" do
    it "should take a version and generate the appropriate template" do
      feed = PachubeDataFormats::Feed.new({})
      PachubeDataFormats::Template.should_receive(:new).with(feed, :json)
      lambda {feed.generate_json("1.0.0")}.should raise_error(NoMethodError)
    end
  end

  describe "#to_xml" do
    it "should call the xml generator with default version" do
      feed = PachubeDataFormats::Feed.new({})
      feed.should_receive(:generate_xml).with("0.5.1").and_return("<xml></xml>")
      feed.to_xml.should == "<xml></xml>"
    end

    it "should accept optional xml version" do
      version = "5"
      feed = PachubeDataFormats::Feed.new({})
      feed.should_receive(:generate_xml).with(version).and_return("<xml></xml>")
      feed.to_xml(:version => version).should == "<xml></xml>"
    end
  end

  describe "#as_json" do
    it "should call the json generator with default version" do
      feed = PachubeDataFormats::Feed.new({})
      feed.should_receive(:generate_json).with("1.0.0").and_return({"title" => "Environment"})
      feed.as_json.should == {"title" => "Environment"}
    end

    it "should accept optional json version" do
      version = "0.6-alpha"
      feed = PachubeDataFormats::Feed.new({})
      feed.should_receive(:generate_json).with(version).and_return({"title" => "Environment"})
      feed.as_json(:version => version).should == {"title" => "Environment"}
    end
  end

  describe "#to_json" do
    it "should call #as_json" do
      feed_hash = {"title" => "Environment"}
      feed = PachubeDataFormats::Feed.new(feed_hash)
      feed.should_receive(:as_json).with({})
      feed.to_json
    end

    it "should pass options through to #as_json" do
      feed_hash = {"title" => "Environment"}
      feed = PachubeDataFormats::Feed.new(feed_hash)
      feed.should_receive(:as_json).with({:crazy => "options"})
      feed.to_json({:crazy => "options"})
    end

    it "should generate datastreams" do
      feed = PachubeDataFormats::Feed.new(feed_as_('hash'))
      feed.datastreams = datastream_as_(:hash)
      JSON.parse(feed.to_json)["datastreams"].should_not be_nil
    end

    it "should pass the output of #as_json to yajl" do
      feed_hash = {"title" => "Environment"}
      feed = PachubeDataFormats::Feed.new(feed_hash)
      feed.should_receive(:as_json).and_return({:awesome => "hash"})
      ::JSON.should_receive(:generate).with({:awesome => "hash"})
      feed.to_json
    end
  end
end

