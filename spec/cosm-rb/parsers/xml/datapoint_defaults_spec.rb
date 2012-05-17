require 'spec_helper'

describe "default datapoint xml parser" do
  it "should convert into attributes hash" do
    @xml = datapoint_as_(:xml)
    Cosm::Datapoint.new(@xml).should fully_represent_datapoint(:xml, @xml)
  end

  it "should handle blank at" do
    @xml = datapoint_as_(:xml, :except_node => :at)
    Cosm::Datapoint.new(@xml).should fully_represent_datapoint(:xml, @xml)
  end

  it "should handle blank value" do
    @xml = datapoint_as_(:xml, :except_node => :value)
    Cosm::Datapoint.new(@xml).should fully_represent_datapoint(:xml, @xml)
  end
end

