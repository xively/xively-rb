require 'spec_helper'

describe "Array extensions" do
  it "should ignore array.split calls" do
    array = ['a', 'b']
    array.split.should == array
  end
end

