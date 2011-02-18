require File.dirname(__FILE__) + '/../../spec_helper'

describe PachubeDataFormats::FeedFormats::PachubeHash do
  it "should inherit from PachubeDataFormats::FeedFormats::Base" do
    PachubeDataFormats::FeedFormats::PachubeHash.new.should be_a_kind_of(PachubeDataFormats::FeedFormats::Base)
  end

  describe "parser" do
    it "should parse a Pachube hash" do
      attrs = {}
      PachubeDataFormats::Feed::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      hash = PachubeDataFormats::FeedFormats::PachubeHash.parse(attrs.clone)
      hash.should == attrs
    end
  end

  describe "generator" do
    it "should generate Pachube hash" do
      attrs = {}
      PachubeDataFormats::Feed::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      hash = PachubeDataFormats::FeedFormats::PachubeHash.generate(attrs.clone)
      hash.should == attrs
    end
  end
end

