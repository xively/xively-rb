require 'spec_helper'

describe "default datapoint json templates" do
  before(:each) do
    @datapoint = Cosm::Datapoint.new(datapoint_as_(:hash).merge("feed_id" => 6545, "datastream_id" => 0))
  end

  it "should represent Pachube datapoints (only used by API v2)" do
    csv = @datapoint.generate_csv("2")
    csv.should == @datapoint.value
  end

  it "should accept a depth option" do
    csv = @datapoint.generate_csv("2", :depth => 1)
    csv.should == @datapoint.value
    csv = @datapoint.generate_csv("2", :depth => 2)
    csv.should == [@datapoint.at.iso8601(6),@datapoint.value].join(',')
    csv = @datapoint.generate_csv("2", :depth => 3)
    csv.should == [@datapoint.datastream_id, @datapoint.at.iso8601(6),@datapoint.value].join(',')
    csv = @datapoint.generate_csv("2", :depth => 4)
    csv.should == [@datapoint.feed_id, @datapoint.datastream_id, @datapoint.at.iso8601(6), @datapoint.value].join(',')
  end

  it "should have an optional full representation" do
    csv = @datapoint.generate_csv("2", :full => true)
    csv.should == [@datapoint.feed_id, @datapoint.datastream_id, @datapoint.at.iso8601(6), @datapoint.value].join(',')
  end

  it "should escape stuff that could upset csv parsers" do
    @datapoint.value = "I \n , am not a csv"
    csv = @datapoint.generate_csv("2")
    csv.should == Cosm::CSV.generate_line([@datapoint.value]).strip
  end

  it "should escape characters that could upset csv parsers via full" do
    @datapoint.value = "I \n , am not a csv"
    csv = @datapoint.generate_csv("2", :full => true)
    csv.should == Cosm::CSV.generate_line([@datapoint.feed_id, @datapoint.datastream_id, @datapoint.at.iso8601(6), @datapoint.value]).strip
  end
end

