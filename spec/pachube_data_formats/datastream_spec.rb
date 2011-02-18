require File.dirname(__FILE__) + '/../spec_helper'

describe PachubeDataFormats::Datastream do

  it "should have a constant that defines the allowed keys" do
    PachubeDataFormats::Datastream::ALLOWED_KEYS.should == %w(id max_value min_value retrieved_at tag_list unit_label unit_symbol unit_type value)
  end

  describe "#initialize" do
    it "should require one parameter" do
      lambda{PachubeDataFormats::Datastream.new}.should raise_exception(ArgumentError, "wrong number of arguments (0 for 1)")
    end

    context "input from json" do
      it "should use the PachubeJSON parser and store the outcome" do
        PachubeDataFormats::DatastreamFormats::PachubeJSON.should_receive(:parse).with(datastream_as_(:json)).and_return({"value" => "001"})
        datastream = PachubeDataFormats::Datastream.new(datastream_as_(:json))
        datastream.attributes.should == {"value" => "001"}
      end
    end

    context "input from hash" do
      it "should use the PachubeHash parser and store the outcome" do
        PachubeDataFormats::DatastreamFormats::PachubeHash.should_receive(:parse).with(datastream_as_(:hash)).and_return({"value" => "one"})
        datastream = PachubeDataFormats::Datastream.new(datastream_as_(:hash))
        datastream.attributes.should == {"value" => "one"}
      end
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


end
