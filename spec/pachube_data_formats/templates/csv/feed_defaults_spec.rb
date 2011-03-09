require File.dirname(__FILE__) + '/../../../spec_helper'

describe "default feed json templates" do
  before(:each) do
    @feed = PachubeDataFormats::Feed.new(feed_as_(:hash))
    @feed.datastreams.each do |ds|
      ds.current_value = "I \n , will , break , you"
    end
  end

  context "2" do
    it "should be the default" do
      @feed.generate_csv("2").should == @feed.to_csv
    end

    it "should represent Pachube JSON (used by API v2)" do
      csv = @feed.generate_csv("2")
      expected_csv = @feed.datastreams.collect do |datastream|
        CSV.generate_line([datastream.id, datastream.updated.iso8601(6), datastream.current_value])
      end.join("\n")
      csv.should == expected_csv
    end

    it "should allow representing full Pachube JSON (used by API v2)" do
      csv = @feed.generate_csv("2", :full => true)
      expected_csv = @feed.datastreams.collect do |datastream|
        CSV.generate_line([@feed.id, datastream.id, datastream.updated.iso8601(6), datastream.current_value])
      end.join("\n")
      csv.should == expected_csv
    end
  end

  context "0.6-alpha" do

    it "should represent Pachube JSON (used by API v1)" do
      csv = @feed.generate_csv("1")
      expected_csv = @feed.datastreams.collect do |datastream|
        CSV.generate_line([datastream.current_value])
      end.join(",")
      csv.should == expected_csv
    end

  end
end

