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
        PachubeDataFormats::Formats::Datastreams::JSON.should_receive(:parse).with(datastream_as_(:json)).and_return({"value" => "001"})
        datastream = PachubeDataFormats::Datastream.new(datastream_as_(:json))
        datastream.attributes.should == {"value" => "001"}
      end
    end

    context "input from hash" do
      it "should use the PachubeHash parser and store the outcome" do
        PachubeDataFormats::Formats::Datastreams::Hash.should_receive(:parse).with(datastream_as_(:hash)).and_return({"value" => "one"})
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

  describe "#as_json" do

    it "should optionally append the json version" do
      version = "1.0.0"
      datastream_hash = {"id" => "env001", "value" => "2344"}
      datastream = PachubeDataFormats::Datastream.new(datastream_hash)
      datastream.as_json(:append_version => true).should == {"id" => "env001", "current_value" => "2344", "version" => version}
    end

    it "should not append the json version by default" do
      datastream_hash = {"id" => "env001", "value" => "2344"}
      datastream = PachubeDataFormats::Datastream.new(datastream_hash)
      datastream.as_json.should == {"id" => "env001", "current_value" => "2344"}
    end

    it "should use the PachubeJSON generator" do
      datastream = PachubeDataFormats::Datastream.new(datastream_as_(:hash))
      PachubeDataFormats::Formats::Datastreams::JSON.should_receive(:generate).with(hash_including(datastream_as_(:hash))).and_return({"stream_id" => "env1"})
      datastream.as_json.should == {"stream_id" => "env1"}
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

  describe "#to_hash" do
    it "should use the PachubeHash generator" do
      datastream = PachubeDataFormats::Datastream.new(datastream_as_(:hash))
      PachubeDataFormats::Formats::Datastreams::Hash.should_receive(:generate).with(datastream_as_(:hash)).and_return({"stream_id" => "env1"})
      datastream.to_hash.should == {"stream_id" => "env1"}
    end
  end

end
