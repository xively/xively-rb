require File.dirname(__FILE__) + '/../../spec_helper'

describe PachubeDataFormats::DatastreamFormats::PachubeHash do
  it "should inherit from PachubeDataFormats::DatastreamFormats::Base" do
    PachubeDataFormats::DatastreamFormats::PachubeHash.new.should be_a_kind_of(PachubeDataFormats::DatastreamFormats::Base)
  end

  describe "parser" do
    it "should parse a Pachube hash" do
      attrs = {}
      PachubeDataFormats::Datastream::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      hash = PachubeDataFormats::DatastreamFormats::PachubeHash.parse(attrs.clone)
      hash.should == attrs
    end
  end

  describe "generator" do
    it "should generate Pachube hash" do
      attrs = {}
      PachubeDataFormats::Datastream::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      hash = PachubeDataFormats::DatastreamFormats::PachubeHash.generate(attrs.clone)
      hash.should == attrs
    end
  end
end

