require 'spec_helper'

describe "String extensions" do
 
  # HACK!!!!
  it "should fail silently if iso8601 called on a non-time object" do
    time_string = "2011-02-16T16:21:01.834174Z"
    time_string.iso8601.should == time_string
    time_string.iso8601(6).should == time_string
  end
end

