require 'spec_helper'

describe "default feed csv parser" do
  describe "csv" do
    it "should convert Pachube CSV v2 into attributes hash" do
      csv = feed_as_(:csv, :version => 'v2')
      feed = Cosm::Feed.new(csv)
      feed.should fully_represent_feed(:csv_v2, csv)
    end

    it "should convert Pachube CSV v1 into attributes hash" do
      csv = feed_as_(:csv, :version => 'v1')
      feed = Cosm::Feed.new(csv)
      feed.should fully_represent_feed(:csv_v1, csv)
    end

    it "should raise an exception if Pachube CSV cannot be detected" do
      csv = feed_as_(:csv, :version => 'unknown')
      lambda {Cosm::Feed.new(csv)}.should raise_exception(Cosm::Parsers::CSV::UnknownVersionError)
    end

    it "should accept manually determining csv version to be v2" do
      csv = feed_as_(:csv, :version => 'unknown')
      feed = Cosm::Feed.new(csv, :v2)
      feed.should fully_represent_feed(:csv_v2, csv)
    end

    it "should accept manually determining csv version to be v1" do
      csv = feed_as_(:csv, :version => 'unknown')
      feed = Cosm::Feed.new(csv, :v1)
      feed.should fully_represent_feed(:csv_v1, csv)
    end
  end
end

