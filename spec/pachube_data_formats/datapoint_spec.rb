require File.dirname(__FILE__) + '/../spec_helper'

describe PachubeDataFormats::Datapoint do

  it "should have a constant that defines the allowed keys" do
    PachubeDataFormats::Datapoint::ALLOWED_KEYS.should == %w(at value feed_id datastream_id)
  end

  describe "#initialize" do
    it "should require one parameter" do
      lambda{PachubeDataFormats::Datapoint.new}.should raise_exception(ArgumentError, "wrong number of arguments (0 for 1)")
    end

    it "should accept xml" do
      datapoint = PachubeDataFormats::Datapoint.new(datapoint_as_(:xml))
      datapoint.value.should == "2000"
    end

    it "should accept json" do
      datapoint = PachubeDataFormats::Datapoint.new(datapoint_as_(:json))
      datapoint.value.should == "2000"
    end

    it "should accept a hash of attributes" do
      datapoint = PachubeDataFormats::Datapoint.new(datapoint_as_(:hash))
      datapoint.value.should == "2000"
    end
  end

  describe "#attributes" do
    it "should return a hash of datapoint properties" do
      attrs = {}
      PachubeDataFormats::Datapoint::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      datapoint = PachubeDataFormats::Datapoint.new(attrs)

      datapoint.attributes.should == attrs
    end

    it "should not return nil values" do
      attrs = {}
      PachubeDataFormats::Datapoint::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["created_at"] = nil
      datapoint = PachubeDataFormats::Datapoint.new(attrs)

      datapoint.attributes.should_not include("created_at")
    end
  end

  describe "#attributes=" do
    it "should accept and save a hash of datapoint properties" do
      datapoint = PachubeDataFormats::Datapoint.new({})

      attrs = {}
      PachubeDataFormats::Datapoint::ALLOWED_KEYS.each do |key|
        value = "key #{rand(1000)}"
        attrs[key] = value
        datapoint.should_receive("#{key}=").with(value)
      end
      datapoint.attributes=(attrs)
    end
  end

  # Provided by PachubeDataFormats::Templates::DatapointDefaults
  describe "#generate_json" do
    it "should take a version and generate the appropriate template" do
      datapoint = PachubeDataFormats::Datapoint.new({})
      PachubeDataFormats::Template.should_receive(:new).with(datapoint, :json)
      lambda {datapoint.generate_json}.should raise_error(NoMethodError)
    end
  end

  describe "#to_csv" do

    it "should call the csv generator with default version (nil as there only is one version)" do
      datapoint = PachubeDataFormats::Datapoint.new({})
      datapoint.should_receive(:generate_csv).with(nil).and_return("3")
      datapoint.to_csv.should == "3"
    end

    it "should accept optional csv version" do
      datapoint = PachubeDataFormats::Datapoint.new({})
      datapoint.should_receive(:generate_csv).with("1").and_return("34")
      datapoint.to_csv(:version => "1").should == "34"
    end

  end
  describe "#to_xml" do

    it "should call the xml generator with default version (nil as there only is one version)" do
      datapoint = PachubeDataFormats::Datapoint.new({})
      datapoint.should_receive(:generate_xml).with(nil).and_return("<xml></xml>")
      datapoint.to_xml.should == "<xml></xml>"
    end

    it "should accept optional xml version" do
      datapoint = PachubeDataFormats::Datapoint.new({})
      datapoint.should_receive(:generate_xml).with("5").and_return("<xml></xml>")
      datapoint.to_xml(:version => "5").should == "<xml></xml>"
    end

  end

  describe "#as_json" do

    it "should call the json generator with default version (nil as there only is one version)" do
      datapoint = PachubeDataFormats::Datapoint.new({})
      datapoint.should_receive(:generate_json).with(nil).and_return({"title" => "Environment"})
      datapoint.as_json.should == {"title" => "Environment"}
    end

    it "should accept optional json version" do
      datapoint = PachubeDataFormats::Datapoint.new({})
      datapoint.should_receive(:generate_json).with("0.6-alpha").and_return({"title" => "Environment"})
      datapoint.as_json(:version => "0.6-alpha").should == {"title" => "Environment"}
    end

  end

  describe "#to_json" do
    it "should call #as_json" do
      datapoint_hash = {"id" => "env001", "value" => "2344"}
      datapoint = PachubeDataFormats::Datapoint.new(datapoint_hash)
      datapoint.should_receive(:as_json).with({})
      datapoint.to_json
    end

    it "should pass options through to #as_json" do
      datapoint_hash = {"id" => "env001", "value" => "2344"}
      datapoint = PachubeDataFormats::Datapoint.new(datapoint_hash)
      datapoint.should_receive(:as_json).with({:crazy => "options"})
      datapoint.to_json({:crazy => "options"})
    end

    it "should pass the output of #as_json to yajl" do
      datapoint_hash = {"id" => "env001", "value" => "2344"}
      datapoint = PachubeDataFormats::Datapoint.new(datapoint_hash)
      datapoint.should_receive(:as_json).and_return({:awesome => "hash"})
      ::JSON.should_receive(:generate).with({:awesome => "hash"})
      datapoint.to_json
    end
  end
end

