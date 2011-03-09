require File.dirname(__FILE__) + '/../../../spec_helper'

describe "default datastream json templates" do
  before(:each) do
    @datastream = PachubeDataFormats::Datastream.new(datastream_as_(:hash))
  end

  context "version 2 (used by API V2)" do

    it "should default to 2" do
      @datastream.generate_csv("2").should == @datastream.to_csv
    end

    it "should only show datapoints if there are any" do
      csv = @datastream.generate_csv("2")
      csv.should == @datastream.datapoints.collect {|dp| "#{dp.at.iso8601(6)},#{dp.value}"}.join("\n")
    end

    it "should represent datastream in Pachube CSV v2 if no datapoints" do
      @datastream.datapoints = []
      csv = @datastream.generate_csv("2")
      csv.should == "#{@datastream.updated.iso8601(6)},#{@datastream.current_value}"
    end

    it "should allow a representation of both" do
      csv = @datastream.generate_csv("2", :complete => true)
      expected = ["#{@datastream.updated.iso8601(6)},#{@datastream.current_value}"]
      @datastream.datapoints.collect {|dp| expected << "#{dp.at.iso8601(6)},#{dp.value}"}
      csv.should == expected.join("\n")
    end

    it "should allow a full representation of datastream" do
      @datastream.datapoints = []
      csv = @datastream.generate_csv("2", :full => true)
      csv.should == "#{@datastream.feed_id},#{@datastream.id},#{@datastream.updated.iso8601(6)},#{@datastream.current_value}"
    end

    it "should allow a full representation of datapoints" do
      csv = @datastream.generate_csv("2", :full => true)
      csv.should == @datastream.datapoints.collect {|dp| "#{@datastream.feed_id},#{@datastream.id},#{dp.at.iso8601(6)},#{dp.value}"}.join("\n")
    end

    it "should allow a full representation of both" do
      csv = @datastream.generate_csv("2", :full => true, :complete => true)
      expected = ["#{@datastream.feed_id},#{@datastream.id},#{@datastream.updated.iso8601(6)},#{@datastream.current_value}"]
      @datastream.datapoints.collect {|dp| expected << "#{@datastream.feed_id},#{@datastream.id},#{dp.at.iso8601(6)},#{dp.value}"}
      csv.should == expected.join("\n")
    end
  end

  context "version 1 (used by API V1)" do

    it "should represent Pachube CSV v1" do
      csv = @datastream.generate_csv("1")
      csv.should == @datastream.current_value
    end

  end
end

