# encoding: utf-8
require 'spec_helper'

describe Cosm::Datastream do

  it "should have a constant that defines the allowed keys" do
    Cosm::Datastream::ALLOWED_KEYS.should == %w(feed_id id feed_creator current_value datapoints max_value min_value tags unit_label unit_symbol unit_type updated datapoints_function)
  end

  describe "validation" do
    before(:each) do
      @datastream = Cosm::Datastream.new
    end

    %w(id).each do |field|
      it "should require a '#{field}'" do
        @datastream.send("#{field}=".to_sym, nil)
        @datastream.should_not be_valid
        @datastream.errors[field.to_sym].should include("can't be blank")
      end
    end

    ["red hat", "foo*", "KYB:FOO"].each do |invalid_id|
      it "should not allow '#{invalid_id}' as an id" do
        @datastream.id = invalid_id
        @datastream.should_not be_valid
        @datastream.errors[:id].should include("is invalid")
      end
    end

    ["üöäÜÖÄ", "ÜÖÄ", "üöä", "current_to_direction-degrees_true-1", "current_to_direction.degrees_true.1"].each do |valid_id|
      it "should allow '#{valid_id}' as an id" do
        @datastream.feed_id = 1234
        @datastream.id = valid_id
        @datastream.should be_valid
        @datastream.errors[:id].should be_empty
      end
    end

    ["red hat", "foo*", 12.05].each do |invalid_feed_id|
      it "should not allow '#{invalid_feed_id}' as a feed_id" do
        @datastream.id = "1"
        @datastream.feed_id = invalid_feed_id
        @datastream.should_not be_valid
        @datastream.errors[:feed_id].should include("is invalid")
      end
    end

    [0, 1234, 102931203, "123"].each do |valid_feed_id|
      it "should allow '#{valid_feed_id}' as a feed_id" do
        @datastream.id = "1"
        @datastream.feed_id = valid_feed_id
        @datastream.should be_valid
        @datastream.errors[:feed_id].should be_empty
      end
    end

    %w(current_value tags).each do |field|
      it "should restrict '#{field}' field length to 255" do
        @datastream.send("#{field}=".to_sym, "a"*256)
        @datastream.should_not be_valid
        @datastream.errors[field.to_sym].should == ["is too long (maximum is 255 characters)"]
      end
    end

    it "should not allow arrays of 255 entries for tags" do
      @datastream.tags = []
      254.times {@datastream.tags << 'a'}
      @datastream.should_not be_valid
      @datastream.errors[:tags].should == ["is too long (maximum is 255 characters)"]
    end

    %w(unit_type current_value).each do |field|
      it "should allow blank '#{field}'" do
        @datastream.send("#{field}=".to_sym, nil)
        @datastream.valid?
        @datastream.errors[field.to_sym].should be_blank
      end
    end

    %w(basicSI derivedSI conversionBasedUnits derivedUnits contextDependentUnits).each do |valid_unit_type|
      it "should allow unit_type of '#{valid_unit_type}'" do
        @datastream.unit_type = valid_unit_type
        @datastream.valid?
        @datastream.errors[:unit_type].should be_blank
      end
    end

    %w(baicSI deriedSI conversinBasedUnits deriedUnits cotextDependentUnits).each do |invalid_unit_type|
      it "should not allow unit_type of '#{invalid_unit_type}'" do
        @datastream.unit_type = invalid_unit_type
        @datastream.valid?
        @datastream.errors[:unit_type].should == ["is not a valid unit_type (pick one from #{Cosm::Datastream::VALID_UNIT_TYPES.join(', ')} or leave blank)"]
      end
    end

  end

  describe "#initialize" do
    it "should create a blank slate when passed no arguments" do
      datastream = Cosm::Datastream.new
      Cosm::Datastream::ALLOWED_KEYS.each do |attr|
        datastream.attributes[attr.to_sym].should be_nil
      end
    end

    %w(xml json hash csv).each do |format|
      it "should accept #{format}" do
        datastream = Cosm::Datastream.new(datastream_as_(format.to_sym))
        datastream.current_value.should == "14"
      end

      %w(to_csv as_json to_xml to_json attributes).each do |output_format|
        it "should be able to output from #{format} using #{output_format}" do
          datastream = Cosm::Datastream.new(datastream_as_(format.to_sym))
          lambda {datastream.send(output_format.to_sym)}.should_not raise_error
        end
      end
    end

    it "should raise known exception if passed json but told xml" do
      expect {
        Cosm::Datastream.new(datastream_as_(:json), :xml)
      }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
    end

    it "should raise known exception if passed csv but told xml" do
      expect {
        Cosm::Datastream.new(datastream_as_(:csv), :xml)
      }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
    end

    it "should raise known exception if passed xml but told json" do
      expect {
        Cosm::Datastream.new(datastream_as_(:xml), :json)
      }.to raise_error(Cosm::Parsers::JSON::InvalidJSONError)
    end

    it "should raise known exception if passed csv but told json" do
      expect {
        Cosm::Datastream.new(datastream_as_(:csv), :json)
      }.to raise_error(Cosm::Parsers::JSON::InvalidJSONError)
    end

    it "should raise known exception if passed json but told csv" do
      expect {
        Cosm::Datastream.new(datastream_as_(:json), :csv)
      }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
    end

    it "should raise known exception if passed xml but told csv" do
      expect {
        Cosm::Datastream.new(datastream_as_(:xml), :csv)
      }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
    end

    it "should raise known exception if told some format we don't accept" do
      expect {
        Cosm::Datastream.new(datastream_as_(:xml), :html)
      }.to raise_error(Cosm::InvalidFormatError)
    end

  end

  describe "#attributes" do
    it "should return a hash of datastream properties" do
      attrs = {}
      Cosm::Datastream::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["datapoints"] = [Cosm::Datapoint.new({"value" => "ein"})]
      datastream = Cosm::Datastream.new(attrs)

      datastream.attributes.should == attrs
    end

    it "should not return nil values" do
      attrs = {}
      Cosm::Datastream::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["created_at"] = nil
      datastream = Cosm::Datastream.new(attrs)

      datastream.attributes.should_not include("created_at")
    end
  end

  describe "#attributes=" do
    it "should accept and save a hash of datastream properties" do
      datastream = Cosm::Datastream.new({})

      attrs = {}
      Cosm::Datastream::ALLOWED_KEYS.each do |key|
        value = "key #{rand(1000)}"
        attrs[key] = value
        datastream.should_receive("#{key}=").with(value)
      end
      datastream.attributes=(attrs)
    end
  end

  context "associated datapoints" do

    describe "#datapoints" do
      it "should return an array of datapoints" do
        datapoints = [Cosm::Datapoint.new(datapoint_as_(:hash))]
        attrs = {"datapoints" => datapoints}
        datastream = Cosm::Datastream.new(attrs)
        datastream.datapoints.each do |ds|
          ds.should be_kind_of(Cosm::Datapoint)
        end
      end

      it "should never be nil" do
        Cosm::Datastream.new({}).datapoints.should == []
      end
    end

    describe "#datapoints=" do
      before(:each) do
        @datastream = Cosm::Datastream.new({})
      end

      it "should be empty if not assigned an array" do
        @datastream.datapoints = "kittens"
        @datastream.datapoints.should be_empty
      end

      it "should accept an array of datapoints and hashes and store an array of datapoints" do
        new_datapoint1 = Cosm::Datapoint.new(datapoint_as_(:hash))
        new_datapoint2 = Cosm::Datapoint.new(datapoint_as_(:hash))
        Cosm::Datapoint.should_receive(:new).with(datapoint_as_(:hash)).and_return(new_datapoint2)

        datapoints = [new_datapoint1, datapoint_as_(:hash)]
        @datastream.datapoints = datapoints
        @datastream.datapoints.length.should == 2
        @datastream.datapoints.should include(new_datapoint1)
        @datastream.datapoints.should include(new_datapoint2)
      end

      it "should accept an array of datapoints and store an array of datapoints" do
        datapoints = [Cosm::Datapoint.new(datapoint_as_(:hash))]
        @datastream.datapoints = datapoints
        @datastream.datapoints.should == datapoints
      end

      it "should accept an array of hashes and store an array of datapoints" do
        new_datapoint = Cosm::Datapoint.new(datapoint_as_(:hash))
        Cosm::Datapoint.should_receive(:new).with(datapoint_as_(:hash)).and_return(new_datapoint)

        datapoints_hash = [datapoint_as_(:hash)]
        @datastream.datapoints = datapoints_hash
        @datastream.datapoints.should == [new_datapoint]
      end
    end
  end

  # Provided by Cosm::Templates::DatastreamDefaults
  describe "#generate_json" do
    it "should take a version and generate the appropriate template" do
      datastream = Cosm::Datastream.new({})
      datastream.generate_json("1.0.0").should == {:version => "1.0.0"}
    end
  end

  describe "#to_csv" do

    it "should call the csv generator with default version" do
      datastream = Cosm::Datastream.new({})
      datastream.should_receive(:generate_csv).with("2", {}).and_return("2")
      datastream.to_csv.should == "2"
    end

    it "should accept optional xml version" do
      datastream = Cosm::Datastream.new({})
      datastream.should_receive(:generate_csv).with("1", {}).and_return("1234,32")
      datastream.to_csv(:version => "1").should == "1234,32"
    end

    it "should accept additional options" do
      datastream = Cosm::Datastream.new({})
      datastream.should_receive(:generate_csv).with("1", {:full => true}).and_return("34")
      datastream.to_csv(:version => "1", :full => true).should == "34"
    end
  end

  describe "#to_xml" do

    it "should call the xml generator with default version" do
      datastream = Cosm::Datastream.new({})
      datastream.should_receive(:generate_xml).with("0.5.1", {}).and_return("<xml></xml>")
      datastream.to_xml.should == "<xml></xml>"
    end

    it "should accept optional xml version" do
      datastream = Cosm::Datastream.new({})
      datastream.should_receive(:generate_xml).with("5", {}).and_return("<xml></xml>")
      datastream.to_xml(:version => "5").should == "<xml></xml>"
    end

  end

  describe "#as_json" do

    it "should call the json generator with default version" do
      datastream = Cosm::Datastream.new({})
      datastream.should_receive(:generate_json).with("1.0.0", {}).and_return({"title" => "Environment"})
      datastream.as_json.should == {"title" => "Environment"}
    end

    it "should accept optional json version" do
      datastream = Cosm::Datastream.new({})
      datastream.should_receive(:generate_json).with("0.6-alpha", {}).and_return({"title" => "Environment"})
      datastream.as_json(:version => "0.6-alpha").should == {"title" => "Environment"}
    end

  end

  describe "#to_json" do
    it "should call #as_json" do
      datastream_hash = {"id" => "env001", "value" => "2344"}
      datastream = Cosm::Datastream.new(datastream_hash)
      datastream.should_receive(:as_json).with({})
      datastream.to_json
    end

    it "should pass options through to #as_json" do
      datastream_hash = {"id" => "env001", "value" => "2344"}
      datastream = Cosm::Datastream.new(datastream_hash)
      datastream.should_receive(:as_json).with({:crazy => "options"})
      datastream.to_json({:crazy => "options"})
    end

    it "should pass the output of #as_json to yajl" do
      datastream_hash = {"id" => "env001", "value" => "2344"}
      datastream = Cosm::Datastream.new(datastream_hash)
      datastream.should_receive(:as_json).and_return({:awesome => "hash"})
      MultiJson.should_receive(:dump).with({:awesome => "hash"})
      datastream.to_json
    end
  end
end

