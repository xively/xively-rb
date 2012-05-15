require 'spec_helper'

describe "default datapoint json parser" do
  before(:each) do
    @datapoint = Cosm::Datapoint.new(datapoint_as_(:json))
  end

  it "should convert into attributes hash" do
    @json = datapoint_as_(:json)
    attributes = @datapoint.from_json(@json)
    json = JSON.parse(@json)
    attributes["at"].should == json["at"]
    attributes["value"].should == json["value"]
  end
end
