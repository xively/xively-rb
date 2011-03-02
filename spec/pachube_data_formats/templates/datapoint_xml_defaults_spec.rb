require File.dirname(__FILE__) + '/../../spec_helper'

describe "default datapoint xml templates" do
  before(:each) do
    @datapoint = PachubeDataFormats::Datapoint.new(datapoint_as_(:hash))
  end

  it "should represent Pachube datapoints" do
    xml = Nokogiri.parse(@datapoint.generate_xml)
    xml.should describe_eeml_for_version("0.5.1")
    xml.should contain_datapoint_eeml_for_version("0.5.1")
  end
end

