require 'spec_helper'

describe Cosm::Datapoint do

  it "should have a constant that defines the allowed keys" do
    Cosm::Datapoint::ALLOWED_KEYS.should == %w(feed_id datastream_id at value)
  end

  describe "validation" do
    before(:each) do
      @datapoint = Cosm::Datapoint.new
    end

    %w(datastream_id value feed_id).each do |field|
      it "should require a '#{field}'" do
        @datapoint.send("#{field}=".to_sym, nil)
        @datapoint.should_not be_valid
        @datapoint.errors[field.to_sym].should include("can't be blank")
      end
    end
  end

  describe "#initialize" do
    it "should create a blank slate when passed no arguments" do
      datapoint = Cosm::Datapoint.new
      Cosm::Datapoint::ALLOWED_KEYS.each do |attr|
        datapoint.attributes[attr.to_sym].should be_nil
      end
    end

    it "should accept xml" do
      datapoint = Cosm::Datapoint.new(datapoint_as_(:xml))
      datapoint.value.should == "2000"
    end

    it "should accept json" do
      datapoint = Cosm::Datapoint.new(datapoint_as_(:json))
      datapoint.value.should == "2000"
    end

    it "should accept a hash of attributes" do
      datapoint = Cosm::Datapoint.new(datapoint_as_(:hash))
      datapoint.value.should == "2000"
    end

    it "should raise known exception if passed json but told xml" do
      expect {
        Cosm::Datapoint.new(datapoint_as_(:json), :xml)
      }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
    end

    it "should raise known exception if passed xml but told json" do
      expect {
        Cosm::Datapoint.new(datapoint_as_(:xml), :json)
      }.to raise_error(Cosm::Parsers::JSON::InvalidJSONError)
    end

    it "should raise known exception if given unknown format" do
      expect {
        Cosm::Datapoint.new(datapoint_as_(:json), :msgpack)
      }.to raise_error(Cosm::InvalidFormatError)
    end
  end

  describe "#attributes" do
    it "should return a hash of datapoint properties" do
      attrs = {}
      Cosm::Datapoint::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      datapoint = Cosm::Datapoint.new(attrs)

      datapoint.attributes.should == attrs
    end

    it "should not return nil values" do
      attrs = {}
      Cosm::Datapoint::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["created_at"] = nil
      datapoint = Cosm::Datapoint.new(attrs)

      datapoint.attributes.should_not include("created_at")
    end
  end

  describe "#attributes=" do
    it "should accept and save a hash of datapoint properties" do
      datapoint = Cosm::Datapoint.new({})

      attrs = {}
      Cosm::Datapoint::ALLOWED_KEYS.each do |key|
        value = "key #{rand(1000)}"
        attrs[key] = value
        datapoint.should_receive("#{key}=").with(value)
      end
      datapoint.attributes=(attrs)
    end
  end

  # Provided by Cosm::Templates::DatapointDefaults
  describe "#generate_json" do
    it "should take a version and generate the appropriate template" do
      now = Time.now
      datapoint = Cosm::Datapoint.new({:at => now, :value => 123})
      datapoint.generate_json.should == {:at => now.iso8601(6), :value => 123}
    end
  end

  describe "#to_csv" do
    it "should call the csv generator with default version (nil as there only is one version)" do
      datapoint = Cosm::Datapoint.new({})
      datapoint.should_receive(:generate_csv).with(nil, {}).and_return("3")
      datapoint.to_csv.should == "3"
    end

    it "should accept optional csv version" do
      datapoint = Cosm::Datapoint.new({})
      datapoint.should_receive(:generate_csv).with("1", {}).and_return("34")
      datapoint.to_csv(:version => "1").should == "34"
    end

    it "should accept additional options" do
      datapoint = Cosm::Datapoint.new({})
      datapoint.should_receive(:generate_csv).with("1", {:full => true}).and_return("34")
      datapoint.to_csv(:version => "1", :full => true).should == "34"
    end
  end

  describe "#to_xml" do

    it "should call the xml generator with default version (nil as there only is one version)" do
      datapoint = Cosm::Datapoint.new({})
      datapoint.should_receive(:generate_xml).with(nil).and_return("<xml></xml>")
      datapoint.to_xml.should == "<xml></xml>"
    end

    it "should accept optional xml version" do
      datapoint = Cosm::Datapoint.new({})
      datapoint.should_receive(:generate_xml).with("5").and_return("<xml></xml>")
      datapoint.to_xml(:version => "5").should == "<xml></xml>"
    end

  end

  describe "#as_json" do

    it "should call the json generator with default version (nil as there only is one version)" do
      datapoint = Cosm::Datapoint.new({})
      datapoint.should_receive(:generate_json).with(nil).and_return({"title" => "Environment"})
      datapoint.as_json.should == {"title" => "Environment"}
    end

    it "should accept optional json version" do
      datapoint = Cosm::Datapoint.new({})
      datapoint.should_receive(:generate_json).with("0.6-alpha").and_return({"title" => "Environment"})
      datapoint.as_json(:version => "0.6-alpha").should == {"title" => "Environment"}
    end

  end

  describe "#to_json" do
    it "should call #as_json" do
      datapoint_hash = {"id" => "env001", "value" => "2344"}
      datapoint = Cosm::Datapoint.new(datapoint_hash)
      datapoint.should_receive(:as_json).with({})
      datapoint.to_json
    end

    it "should pass options through to #as_json" do
      datapoint_hash = {"id" => "env001", "value" => "2344"}
      datapoint = Cosm::Datapoint.new(datapoint_hash)
      datapoint.should_receive(:as_json).with({:crazy => "options"})
      datapoint.to_json({:crazy => "options"})
    end

    it "should pass the output of #as_json to yajl" do
      datapoint_hash = {"id" => "env001", "value" => "2344"}
      datapoint = Cosm::Datapoint.new(datapoint_hash)
      datapoint.should_receive(:as_json).and_return({:awesome => "hash"})
      MultiJson.should_receive(:dump).with({:awesome => "hash"})
      datapoint.to_json
    end
  end
end

