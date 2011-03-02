require File.dirname(__FILE__) + '/../../spec_helper'

describe "default datapoint xml parser" do
  it "should convert into attributes hash" do
    @xml = datapoint_as_(:xml)
    PachubeDataFormats::Datapoint.new(@xml).should fully_represent_datapoint(:xml, @xml)
  end

  it "should handle blank at" do
    @xml = datapoint_as_(:xml, :except_node => :at)
    PachubeDataFormats::Datapoint.new(@xml).should fully_represent_datapoint(:xml, @xml)
  end

  it "should handle blank value" do
    @xml = datapoint_as_(:xml, :except_node => :value)
    PachubeDataFormats::Datapoint.new(@xml).should fully_represent_datapoint(:xml, @xml)
  end
end

