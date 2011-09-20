require 'spec_helper'

describe PachubeDataFormats::Trigger do

  it "should have a constant that defines the allowed keys" do
    PachubeDataFormats::Trigger::ALLOWED_KEYS.should == %w(threshold_value user notified_at url trigger_type id environment_id stream_id)
  end

  describe "validation" do
    before(:each) do
      @trigger = PachubeDataFormats::Trigger.new
    end

    %w(url stream_id environment_id user).each do |field|
      it "should require a '#{field}'" do
        @trigger.send("#{field}=".to_sym, nil)
        @trigger.should_not be_valid
        @trigger.errors[field.to_sym].should include("can't be blank")
      end
    end
  end

  describe "#initialize" do
    it "should create a blank slate when passed no arguments" do
      trigger = PachubeDataFormats::Trigger.new
      PachubeDataFormats::Trigger::ALLOWED_KEYS.each do |attr|
        trigger.attributes[attr.to_sym].should be_nil
      end
    end

    it "should accept xml" do
      trigger = PachubeDataFormats::Trigger.new(trigger_as_(:xml))
      trigger.url.should == "http://www.postbin.org/zc9sca"
    end

    it "should accept json" do
      trigger = PachubeDataFormats::Trigger.new(trigger_as_(:json))
      trigger.url.should == "http://www.postbin.org/zc9sca"
    end

    it "should accept a hash of attributes" do
      trigger = PachubeDataFormats::Trigger.new(trigger_as_(:hash))
      trigger.url.should == "http://www.postbin.org/zc9sca"
    end
  end

  describe "#attributes" do
    it "should return a hash of datapoint properties" do
      attrs = {}
      PachubeDataFormats::Trigger::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      trigger = PachubeDataFormats::Trigger.new(attrs)

      trigger.attributes.should == attrs
    end

    it "should not return nil values" do
      attrs = {}
      PachubeDataFormats::Trigger::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["notified_at"] = nil
      trigger = PachubeDataFormats::Trigger.new(attrs)

      trigger.attributes.should_not include("notified_at")
    end
  end

  describe "#attributes=" do
    it "should accept and save a hash of datapoint properties" do
      trigger = PachubeDataFormats::Trigger.new({})

      attrs = {}
      PachubeDataFormats::Trigger::ALLOWED_KEYS.each do |key|
        value = "key #{rand(1000)}"
        attrs[key] = value
        trigger.should_receive("#{key}=").with(value)
      end
      trigger.attributes=(attrs)
    end
  end

  describe "#as_json" do
    it "should call the json generator" do
      trigger = PachubeDataFormats::Trigger.new({})
      trigger.should_receive(:generate_json).and_return({"title" => "Environment"})
      trigger.as_json.should == {"title" => "Environment"}
    end
  end

  describe "#to_json" do
    it "should call #as_json" do
      trigger_hash = {"title" => "Environment"}
      trigger = PachubeDataFormats::Trigger.new(trigger_hash)
      trigger.should_receive(:as_json).with({})
      trigger.to_json
    end

    it "should pass options through to #as_json" do
      trigger_hash = {"title" => "Environment"}
      trigger = PachubeDataFormats::Trigger.new(trigger_hash)
      trigger.should_receive(:as_json).with({:crazy => "options"})
      trigger.to_json({:crazy => "options"})
    end

    it "should pass the output of #as_json to yajl" do
      trigger_hash = {"title" => "Environment"}
      trigger = PachubeDataFormats::Trigger.new(trigger_hash)
      trigger.should_receive(:as_json).and_return({:awesome => "hash"})
      ::JSON.should_receive(:generate).with({:awesome => "hash"})
      trigger.to_json
    end
  end

end

