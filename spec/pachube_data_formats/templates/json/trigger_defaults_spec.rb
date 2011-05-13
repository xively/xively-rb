require File.dirname(__FILE__) + '/../../../spec_helper'

describe "default feed json templates" do
  before(:each) do
    @trigger = PachubeDataFormats::Trigger.new(trigger_as_(:hash))
  end

  it "should represent Pachube JSON (used by API v2)" do
    json = @trigger.generate_json
    json[:id].should == @trigger.id
    json[:threshold_value].should == @trigger.threshold_value
    json[:notified_at].should == nil
    json[:url].should == @trigger.url
    json[:trigger_type].should == @trigger.trigger_type
    json[:stream_id].should == @trigger.stream_id
    json[:environment_id].should == @trigger.environment_id
    json[:user].should == @trigger.user
  end
end
