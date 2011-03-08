require File.dirname(__FILE__) + '/../../../spec_helper'

describe "default datapoint json templates" do
  before(:each) do
    @datapoint = PachubeDataFormats::Datapoint.new(datapoint_as_(:hash).merge("feed_id" => 6545, "datastream_id" => 0))
  end

  it "should represent Pachube datapoints (only used by API v2)" do
    csv = @datapoint.generate_csv("2")
    csv.should == @datapoint.value
  end

  it "should have an optional full representation" do
    csv = @datapoint.generate_csv("2", :full => true)
    csv.should == [@datapoint.feed_id, @datapoint.datastream_id, @datapoint.at.iso8601(6), @datapoint.value].join(',')
  end
end

