require 'spec_helper'

describe "default feed json templates" do
  before(:each) do
    @feed = Cosm::Feed.new(feed_as_(:hash))
    @feed.datastreams.each do |ds|
      ds.current_value = "I \n , will , break , you"
      ds.datapoints.each do |dp|
        dp.value = "one,data,point"
      end
    end
  end

  context "2 (used by API v2)" do
    it "should be the default" do
      @feed.generate_csv("2").should == @feed.to_csv
    end

    it "should represent Pachube JSON" do
      @feed.datastreams.each do |ds|
        ds.datapoints = []
      end
      csv = @feed.generate_csv("2")
      expected_csv = @feed.datastreams.collect do |datastream|
        Cosm::CSV.generate_line([datastream.id, datastream.updated.iso8601(6), datastream.current_value]).strip
      end.join("\n")
      csv.should == expected_csv
    end

    it "should allow representing full Pachube JSON" do
      @feed.datastreams.each do |ds|
        ds.datapoints = []
      end
      csv = @feed.generate_csv("2", :full => true)
      expected_csv = @feed.datastreams.collect do |datastream|
        Cosm::CSV.generate_line([@feed.id, datastream.id, datastream.updated.iso8601(6), datastream.current_value]).strip
      end.join("\n")
      csv.should == expected_csv
    end

    it "should represent Pachube JSON with datapoints" do
      csv = @feed.generate_csv("2")
      expected_csv = @feed.datastreams.collect do |datastream|
        if datastream.datapoints.any?
          datastream.datapoints.collect {|dp| Cosm::CSV.generate_line([datastream.id, dp.at.iso8601(6), dp.value]).strip }
        else
          Cosm::CSV.generate_line([datastream.id, datastream.updated.iso8601(6), datastream.current_value]).strip
        end
      end.join("\n")
      csv.should == expected_csv
    end

    it "should allow representing full Pachube JSON with datapoints" do
      csv = @feed.generate_csv("2", :full => true)
      expected_csv = @feed.datastreams.collect do |datastream|
        if datastream.datapoints.any?
          datastream.datapoints.collect {|dp| Cosm::CSV.generate_line([@feed.id, datastream.id, dp.at.iso8601(6), dp.value]).strip }
        else
          Cosm::CSV.generate_line([@feed.id, datastream.id, datastream.updated.iso8601(6), datastream.current_value]).strip
        end
      end.join("\n")
      csv.should == expected_csv
    end
  end

  context "0.6-alpha (used by API v1)" do

    it "should represent Pachube JSON" do
      csv = @feed.generate_csv("1")
      expected_csv = @feed.datastreams.collect do |datastream|
        Cosm::CSV.generate_line([datastream.current_value]).strip
      end.join(",")
      csv.should == expected_csv
    end

  end
end

