require 'spec_helper'

describe "default datapoint json templates" do
  before(:each) do
    @datapoint = Xively::Datapoint.new(datapoint_as_(:hash))
  end

  it "should represent Pachube datapoints (only used by API v2)" do
    json = @datapoint.generate_json
    json[:value].should == @datapoint.value
    json[:at].should == @datapoint.at.iso8601(6)
  end
end

