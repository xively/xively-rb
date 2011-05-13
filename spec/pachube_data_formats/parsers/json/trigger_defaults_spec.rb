require File.dirname(__FILE__) + '/../../../spec_helper'

describe "default trigger json parser" do
  before(:each) do
    @trigger = PachubeDataFormats::Trigger.new(trigger_as_(:json))
  end

  it "should convert into attributes hash" do
    @json = trigger_as_(:json)
    attributes = @trigger.from_json(@json)
    json = JSON.parse(@json)
    PachubeDataFormats::Trigger::ALLOWED_KEYS.each do |key|
      attributes[key].should == json[key]
    end
  end
end
