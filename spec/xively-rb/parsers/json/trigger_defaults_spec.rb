require 'spec_helper'

describe "default trigger json parser" do
  before(:each) do
    @trigger = Xively::Trigger.new(trigger_as_(:json))
  end

  it "should convert into attributes hash" do
    @json = trigger_as_(:json)
    attributes = @trigger.from_json(@json)
    json = MultiJson.load(@json)
    Xively::Trigger::ALLOWED_KEYS.each do |key|
      attributes[key].should == json[key]
    end
  end

  it "should raise known exception if passed garbage as json" do
    expect {
      Xively::Trigger.new("This is not JSON", :json)
    }.to raise_error(Xively::Parsers::JSON::InvalidJSONError)
  end
end
