require 'spec_helper'

describe "default datapoint xml parser" do
  it "should convert into attributes hash" do
    @xml = datapoint_as_(:xml)
    Xively::Datapoint.new(@xml).should fully_represent_datapoint(:xml, @xml)
  end

  it "should handle blank at" do
    @xml = datapoint_as_(:xml, :except_node => :at)
    Xively::Datapoint.new(@xml).should fully_represent_datapoint(:xml, @xml)
  end

  it "should handle blank value" do
    @xml = datapoint_as_(:xml, :except_node => :value)
    Xively::Datapoint.new(@xml).should fully_represent_datapoint(:xml, @xml)
  end
end

