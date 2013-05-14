require 'spec_helper'

describe Xively::Trigger do

  it "should have a constant that defines the allowed keys" do
    Xively::Trigger::ALLOWED_KEYS.should == %w(threshold_value user notified_at url trigger_type id environment_id stream_id)
  end

  describe "validation" do
    before(:each) do
      @trigger = Xively::Trigger.new
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
      trigger = Xively::Trigger.new
      Xively::Trigger::ALLOWED_KEYS.each do |attr|
        trigger.attributes[attr.to_sym].should be_nil
      end
    end

    it "should accept xml" do
      trigger = Xively::Trigger.new(trigger_as_(:xml))
      trigger.url.should == "http://www.postbin.org/zc9sca"
    end

    it "should accept json" do
      trigger = Xively::Trigger.new(trigger_as_(:json))
      trigger.url.should == "http://www.postbin.org/zc9sca"
    end

    it "should accept a hash of attributes" do
      trigger = Xively::Trigger.new(trigger_as_(:hash))
      trigger.url.should == "http://www.postbin.org/zc9sca"
    end

    context "specifying format explicitly" do
      it "should raise known exception if passed json but told xml" do
        expect {
          Xively::Trigger.new(trigger_as_(:json), :xml)
        }.to raise_error(Xively::Parsers::XML::InvalidXMLError)
      end

      it "should raise known exception if passed xml but told json" do
        expect {
          Xively::Trigger.new(trigger_as_(:json), :xml)
        }.to raise_error(Xively::Parsers::XML::InvalidXMLError)
      end

      it "should raise known exception if passed unknown format" do
        expect {
          Xively::Trigger.new(trigger_as_(:json), :png)
        }.to raise_error(Xively::InvalidFormatError)
      end
    end

    context "specifying format" do
      it "should raise known exception if told xml but given json" do
        expect {
          Xively::Trigger.new(trigger_as_(:json), :xml)
        }.to raise_error(Xively::Parsers::XML::InvalidXMLError)
      end

      it "should raise known exception if told json but given xml" do
        expect {
          Xively::Trigger.new(trigger_as_(:xml), :json)
        }.to raise_error(Xively::Parsers::JSON::InvalidJSONError)
      end

      it "should raise known exception if given unknown format" do
        expect {
          Xively::Trigger.new(trigger_as_(:xml), :gif)
        }.to raise_error(Xively::InvalidFormatError)
      end
    end
  end

  describe "#attributes" do
    it "should return a hash of datapoint properties" do
      attrs = {}
      Xively::Trigger::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      trigger = Xively::Trigger.new(attrs)

      trigger.attributes.should == attrs
    end

    it "should not return nil values" do
      attrs = {}
      Xively::Trigger::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["notified_at"] = nil
      trigger = Xively::Trigger.new(attrs)

      trigger.attributes.should_not include("notified_at")
    end
  end

  describe "#attributes=" do
    it "should accept and save a hash of datapoint properties" do
      trigger = Xively::Trigger.new({})

      attrs = {}
      Xively::Trigger::ALLOWED_KEYS.each do |key|
        value = "key #{rand(1000)}"
        attrs[key] = value
        trigger.should_receive("#{key}=").with(value)
      end
      trigger.attributes=(attrs)
    end
  end

  describe "#as_json" do
    it "should call the json generator" do
      trigger = Xively::Trigger.new({})
      trigger.should_receive(:generate_json).and_return({"title" => "Environment"})
      trigger.as_json.should == {"title" => "Environment"}
    end
  end

  describe "#to_json" do
    it "should call #as_json" do
      trigger_hash = {"title" => "Environment"}
      trigger = Xively::Trigger.new(trigger_hash)
      trigger.should_receive(:as_json).with({})
      trigger.to_json
    end

    it "should pass options through to #as_json" do
      trigger_hash = {"title" => "Environment"}
      trigger = Xively::Trigger.new(trigger_hash)
      trigger.should_receive(:as_json).with({:crazy => "options"})
      trigger.to_json({:crazy => "options"})
    end

    it "should pass the output of #as_json to yajl" do
      trigger_hash = {"title" => "Environment"}
      trigger = Xively::Trigger.new(trigger_hash)
      trigger.should_receive(:as_json).and_return({:awesome => "hash"})
      MultiJson.should_receive(:dump).with({:awesome => "hash"})
      trigger.to_json
    end
  end

end

