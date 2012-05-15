require 'spec_helper'

describe "Cosm::Client" do
  it "should have the base uri defined" do
    Cosm::Client.base_uri.should == 'https://api.cosm.com'
  end
end
