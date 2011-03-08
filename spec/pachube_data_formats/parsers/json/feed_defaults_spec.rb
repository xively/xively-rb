require File.dirname(__FILE__) + '/../../../spec_helper'

describe "default feed json parser" do
  describe "json" do
    it "should convert Pachube JSON 1.0.0 (used by API v2) into attributes hash" do
      json = feed_as_(:json)
      feed = PachubeDataFormats::Feed.new(json)
      feed.should fully_represent_feed(:json, json)
    end

    it "should convert Pachube JSON 0.6-alpha (used by API v1) into attributes hash" do
      json = feed_as_(:json, :version => "0.6-alpha")
      feed = PachubeDataFormats::Feed.new(json)
      feed.should fully_represent_feed(:json, json)
    end
  end
end

