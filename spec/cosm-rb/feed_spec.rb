require 'spec_helper'

describe Cosm::Feed do

  it "should have a constant that defines the allowed keys" do
    Cosm::Feed::ALLOWED_KEYS.should == %w(id creator owner_login datastreams description email feed icon location_disposition location_domain location_ele location_exposure location_lat location_lon location_name location_waypoints private status tags title updated created website auto_feed_url csv_version)
  end

  context "attr accessors" do
    before(:each) do
      @feed = Cosm::Feed.new(feed_as_(:json))
    end

    describe "setting whitelisted fields" do
      Cosm::Feed::ALLOWED_KEYS.each do |key|
        it "##{key}=" do
          lambda {
            @feed.send("#{key}=", key)
          }.should_not raise_error
        end
      end
    end

    describe "getting whitelisted fields" do
      Cosm::Feed::ALLOWED_KEYS.each do |key|
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

  describe "validation" do
    %w(title).each do |field|
      it "should require a '#{field}'" do
        feed = Cosm::Feed.new
        feed.send("#{field}=".to_sym, nil)
        feed.should_not be_valid
        feed.errors[field.to_sym].should == ["can't be blank"]
      end
    end

    it "should not allow duplicate datastreams" do
      feed = Cosm::Feed.new
      feed.datastreams = [Cosm::Datastream.new('id' => '1'), Cosm::Datastream.new('id' => '1')]
      feed.should_not be_valid
      feed.errors[:datastreams].should == ["can't have duplicate IDs: 1"]
    end

    it "should validate all datastreams" do
      feed = Cosm::Feed.new
      feed.datastreams = [Cosm::Datastream.new('id' => '')]
      feed.should_not be_valid
      feed.errors[:datastreams_id].should == ["can't be blank"]
    end
  end

  describe "#initialize" do
    it "should create a blank slate when passed no arguments" do
      feed = Cosm::Feed.new
      Cosm::Feed::ALLOWED_KEYS.each do |attr|
        feed.attributes[attr.to_sym].should be_nil
      end
    end

    %w(xml json hash).each do |format|
      it "should accept #{format}" do
        feed = Cosm::Feed.new(feed_as_(format.to_sym))
        feed.title.downcase.should == "cosm office environment"
      end

      %w(to_csv as_json to_xml to_json attributes).each do |output_format|
        it "should be able to output from #{format} using #{output_format}" do
          feed = Cosm::Feed.new(feed_as_(format.to_sym))
          lambda {feed.send(output_format.to_sym)}.should_not raise_error
        end
      end
    end

    context "specifying format" do
      it "should raise known exception if told xml but given csv" do
        expect {
          Cosm::Feed.new(feed_as_(:csv), :v2, :xml)
        }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
      end

      it "should raise known exception if told xml but given json" do
        expect {
          Cosm::Feed.new(feed_as_(:json), nil, :xml)
        }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
      end

      it "should raise known exception if told json but given xml" do
        expect {
          Cosm::Feed.new(feed_as_(:xml), nil, :json)
        }.to raise_error(Cosm::Parsers::JSON::InvalidJSONError)
      end

      it "should raise known exception if told json but given csv" do
        expect {
          Cosm::Feed.new(feed_as_(:csv), nil, :json)
        }.to raise_error(Cosm::Parsers::JSON::InvalidJSONError)
      end

      it "should raise known exception if told csv but given xml" do
        expect {
          Cosm::Feed.new(feed_as_(:xml), :v2, :csv)
        }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
      end

      it "should raise known exception if told csv but given json" do
        expect {
          Cosm::Feed.new(feed_as_(:json), :v2, :csv)
        }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
      end

      it "should raise known exception if told format is something unknown" do
        expect {
          Cosm::Feed.new(feed_as_(:json), :v2, :msgpack)
        }.to raise_error(Cosm::InvalidFormatError)
      end
    end
  end

  describe "#attributes" do
    it "should return a hash of feed properties" do
      attrs = {}
      Cosm::Feed::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["datastreams"] = [Cosm::Datastream.new({"id" => "ein"})]
      feed = Cosm::Feed.new(attrs)

      feed.attributes.should == attrs
    end

    it "should contain csv_version in the allowed keys" do
      Cosm::Feed::ALLOWED_KEYS.should include("csv_version")
    end

    it "should not return nil values" do
      attrs = {}
      Cosm::Feed::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["created_at"] = nil
      feed = Cosm::Feed.new(attrs)

      feed.attributes.should_not include("created_at")
    end
  end

  describe "#attributes=" do
    it "should accept and save a hash of feed properties" do
      feed = Cosm::Feed.new({})

      attrs = {}
      Cosm::Feed::ALLOWED_KEYS.each do |key|
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
        datastreams = [Cosm::Datastream.new(datastream_as_(:hash))]
        attrs = {"datastreams" => datastreams}
        feed = Cosm::Feed.new(attrs)
        feed.datastreams.each do |ds|
          ds.should be_kind_of(Cosm::Datastream)
        end
      end

      it "should default to an empty array" do
        feed = Cosm::Feed.new({})
        feed.datastreams.should == []
      end
    end

    describe "#datastreams=" do
      before(:each) do
        @feed = Cosm::Feed.new({})
      end

      it "should return an empty array if not an array" do
        @feed.datastreams = "kittens"
        @feed.datastreams.should be_empty
      end

      it "should accept an array of datastreams and hashes and store an array of datastreams" do
        new_datastream1 = Cosm::Datastream.new(datastream_as_(:hash))
        new_datastream2 = Cosm::Datastream.new(datastream_as_(:hash))
        Cosm::Datastream.should_receive(:new).with(datastream_as_(:hash)).and_return(new_datastream2)

        datastreams = [new_datastream1, datastream_as_(:hash)]
        @feed.datastreams = datastreams
        @feed.datastreams.length.should == 2
        @feed.datastreams.should include(new_datastream1)
        @feed.datastreams.should include(new_datastream2)
      end

      it "should accept an array of datastreams and store an array of datastreams" do
        datastreams = [Cosm::Datastream.new(datastream_as_(:hash))]
        @feed.datastreams = datastreams
        @feed.datastreams.should == datastreams
      end

      it "should accept an array of hashes and store an array of datastreams" do
        new_datastream = Cosm::Datastream.new(datastream_as_(:hash))
        Cosm::Datastream.should_receive(:new).with(datastream_as_(:hash)).and_return(new_datastream)

        datastreams_hash = [datastream_as_(:hash)]
        @feed.datastreams = datastreams_hash
        @feed.datastreams.should == [new_datastream]
      end

      it "should accept an array of subclass of datastream and store an array of datastreams" do
        class OurSpecialDatastreamClass < Cosm::Datastream
          attr_accessor :something_new
        end

        datastreams = [OurSpecialDatastreamClass.new(datastream_as_(:hash))]
        @feed.datastreams = datastreams
        @feed.datastreams.should == datastreams
      end
    end

  end

  # Provided by Cosm::Templates::FeedDefaults
  describe "#generate_json" do
    it "should take a version and generate the appropriate template" do
      feed = Cosm::Feed.new({})
      feed.generate_json("1.0.0").should == {:version => "1.0.0"}
    end
  end

  describe "#to_csv" do
    it "should call the csv generator with default version" do
      feed = Cosm::Feed.new({})
      feed.should_receive(:generate_csv).with("2", {}).and_return("1,2,3,4")
      feed.to_csv.should == "1,2,3,4"
    end

    it "should accept optional csv version" do
      version = "1"
      feed = Cosm::Feed.new({})
      feed.should_receive(:generate_csv).with(version, {}).and_return("1,2,3,4")
      feed.to_csv(:version => version).should == "1,2,3,4"
    end

    it "should accept additional options" do
      version = "1"
      feed = Cosm::Feed.new({})
      feed.should_receive(:generate_csv).with(version, :full => true).and_return("1,2,3,4")
      feed.to_csv(:version => version, :full => true).should == "1,2,3,4"
    end
  end

  describe "#to_xml" do
    it "should call the xml generator with default version" do
      feed = Cosm::Feed.new({})
      feed.should_receive(:generate_xml).with("0.5.1", {}).and_return("<xml></xml>")
      feed.to_xml.should == "<xml></xml>"
    end

    it "should accept optional xml version" do
      version = "5"
      feed = Cosm::Feed.new({})
      feed.should_receive(:generate_xml).with(version, {}).and_return("<xml></xml>")
      feed.to_xml(:version => version).should == "<xml></xml>"
    end
  end

  describe "#as_json" do
    it "should call the json generator with default version" do
      feed = Cosm::Feed.new({})
      feed.should_receive(:generate_json).with("1.0.0", {}).and_return({"title" => "Environment"})
      feed.as_json.should == {"title" => "Environment"}
    end

    it "should accept optional json version" do
      version = "0.6-alpha"
      feed = Cosm::Feed.new({})
      feed.should_receive(:generate_json).with(version, {}).and_return({"title" => "Environment"})
      feed.as_json(:version => version).should == {"title" => "Environment"}
    end
  end

  describe "#to_json" do
    it "should call #as_json" do
      feed_hash = {"title" => "Environment"}
      feed = Cosm::Feed.new(feed_hash)
      feed.should_receive(:as_json).with({})
      feed.to_json
    end

    it "should pass options through to #as_json" do
      feed_hash = {"title" => "Environment"}
      feed = Cosm::Feed.new(feed_hash)
      feed.should_receive(:as_json).with({:crazy => "options"})
      feed.to_json({:crazy => "options"})
    end

    it "should generate datastreams" do
      feed = Cosm::Feed.new(feed_as_('hash'))
      feed.datastreams = datastream_as_(:hash)
      MultiJson.load(feed.to_json)["datastreams"].should_not be_nil
    end

    it "should pass the output of #as_json to yajl" do
      feed_hash = {"title" => "Environment"}
      feed = Cosm::Feed.new(feed_hash)
      feed.should_receive(:as_json).and_return({:awesome => "hash"})
      MultiJson.should_receive(:dump).with({:awesome => "hash"})
      feed.to_json
    end
  end
end

