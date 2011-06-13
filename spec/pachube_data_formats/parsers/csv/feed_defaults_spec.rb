require File.dirname(__FILE__) + '/../../../spec_helper'

describe "default feed csv parser" do
  describe "csv" do
    it "should convert Pachube CSV v2 into attributes hash" do
      csv = feed_as_(:csv, :version => 'v2')
      feed = PachubeDataFormats::Feed.new(csv)
      feed.should fully_represent_feed(:csv_v2, csv)
    end

    it "should convert Pachube CSV v1 into attributes hash" do
      csv = feed_as_(:csv, :version => 'v1')
      feed = PachubeDataFormats::Feed.new(csv)
      feed.should fully_represent_feed(:csv_v1, csv)
    end

    it "should raise an exception if Pachube CSV cannot be detected" do
      csv = feed_as_(:csv, :version => 'unknown')
      lambda {PachubeDataFormats::Feed.new(csv)}.should raise_exception(PachubeDataFormats::Parsers::CSV::UnknownVersionError)
    end

    it "should accept manually determining csv version to be v2" do
      csv = feed_as_(:csv, :version => 'unknown')
      feed = PachubeDataFormats::Feed.new(csv, :v2)
      feed.should fully_represent_feed(:csv_v2, csv)
    end

    it "should accept manually determining csv version to be v1" do
      csv = feed_as_(:csv, :version => 'unknown')
      feed = PachubeDataFormats::Feed.new(csv, :v1)
      feed.should fully_represent_feed(:csv_v1, csv)
    end
    # it "should convert Pachube JSON 0.6-alpha (used by API v1) into attributes hash" do
    #   json = feed_as_(:json, :version => "0.6-alpha")
    #   feed = PachubeDataFormats::Feed.new(json)
    #   feed.should fully_represent_feed(:json, json)
    # end
  end
end

