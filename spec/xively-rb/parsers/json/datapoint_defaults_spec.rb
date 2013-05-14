require 'spec_helper'

describe "default datapoint json parser" do
  before(:each) do
    @datapoint = Xively::Datapoint.new(datapoint_as_(:json))
  end

  it "should convert into attributes hash" do
    @json = datapoint_as_(:json)
    attributes = @datapoint.from_json(@json)
    json = MultiJson.load(@json)
    attributes["at"].should == json["at"]
    attributes["value"].should == json["value"]
  end

  it "should raise known exeception if passed garbage as json" do
    expect {
      Xively::Datapoint.new("This is not\nJSON", :json)
    }.to raise_error(Xively::Parsers::JSON::InvalidJSONError)
  end
end
