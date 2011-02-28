require File.dirname(__FILE__) + '/../spec_helper'

describe PachubeDataFormats::Datastream do

  it "should have a constant that defines the allowed keys" do
    PachubeDataFormats::Datastream::ALLOWED_KEYS.should == %w(current_value id max_value min_value tags unit_label unit_symbol unit_type updated)
  end

  describe "#initialize" do
    it "should require one parameter" do
      lambda{PachubeDataFormats::Datastream.new}.should raise_exception(ArgumentError, "wrong number of arguments (0 for 1)")
    end

    it "should accept json" do
      datastream = PachubeDataFormats::Datastream.new(datastream_as_(:json))
      datastream.current_value.should == "14"
    end

    it "should accept a hash of attributes" do
      datastream = PachubeDataFormats::Datastream.new(datastream_as_(:hash))
      datastream.current_value.should == "14"
    end
  end

  describe "#attributes" do
    it "should return a hash of datastream properties" do
      attrs = {}
      PachubeDataFormats::Datastream::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      datastream = PachubeDataFormats::Datastream.new(attrs)

      datastream.attributes.should == attrs
    end

    it "should not return nil values" do
      attrs = {}
      PachubeDataFormats::Datastream::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["created_at"] = nil
      datastream = PachubeDataFormats::Datastream.new(attrs)

      datastream.attributes.should_not include("created_at")
    end
  end

  describe "#attributes=" do
    it "should accept and save a hash of datastream properties" do
      datastream = PachubeDataFormats::Datastream.new({})

      attrs = {}
      PachubeDataFormats::Datastream::ALLOWED_KEYS.each do |key|
        value = "key #{rand(1000)}"
        attrs[key] = value
        datastream.should_receive("#{key}=").with(value)
      end
      datastream.attributes=(attrs)
    end
  end

  # Provided by PachubeDataFormats::Templates::DatastreamDefaults
  describe "#generate_json" do
    it "should take a version and generate the appropriate template" do
      datastream = PachubeDataFormats::Datastream.new({})
      PachubeDataFormats::Template.should_receive(:new).with(datastream, :json)
      lambda {datastream.generate_json("1.0.0")}.should raise_error(NoMethodError)
    end
  end

  describe "#as_json" do

    it "should call the json generator with default version" do
      datastream = PachubeDataFormats::Datastream.new({})
      datastream.should_receive(:generate_json).with("1.0.0").and_return({"title" => "Environment"})
      datastream.as_json.should == {"title" => "Environment"}
    end

    it "should accept optional json version" do
      datastream = PachubeDataFormats::Datastream.new({})
      datastream.should_receive(:generate_json).with("0.6-alpha").and_return({"title" => "Environment"})
      datastream.as_json(:version => "0.6-alpha").should == {"title" => "Environment"}
    end

  end

  describe "#to_json" do
    it "should call #as_json" do
      datastream_hash = {"id" => "env001", "value" => "2344"}
      datastream = PachubeDataFormats::Datastream.new(datastream_hash)
      datastream.should_receive(:as_json).with({})
      datastream.to_json
    end

    it "should pass options through to #as_json" do
      datastream_hash = {"id" => "env001", "value" => "2344"}
      datastream = PachubeDataFormats::Datastream.new(datastream_hash)
      datastream.should_receive(:as_json).with({:crazy => "options"})
      datastream.to_json({:crazy => "options"})
    end

    it "should pass the output of #as_json to yajl" do
      datastream_hash = {"id" => "env001", "value" => "2344"}
      datastream = PachubeDataFormats::Datastream.new(datastream_hash)
      datastream.should_receive(:as_json).and_return({:awesome => "hash"})
      ::JSON.should_receive(:generate).with({:awesome => "hash"})
      datastream.to_json
    end
  end
end

