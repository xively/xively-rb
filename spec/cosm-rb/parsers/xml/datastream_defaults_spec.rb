require 'spec_helper'

describe "default datastream xml parser" do
  context "0.5.1 (used by API v2)" do
    it "should convert into attributes hash" do
      xml = datastream_as_(:xml)
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, xml)
    end

    it "should convert into attributes hash when no version string but correct xmlns" do
      xml = datastream_as_(:xml, :omit_version => true)
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, datastream_as_(:xml))
    end

    it "should handle blank tags" do
      xml = datastream_as_(:xml, :except_node => :tag)
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, xml)
    end

    it "should handle blank units" do
      xml = datastream_as_(:xml, :except_node => :unit)
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, xml)
    end

    it "should handle missing unit attributes" do
      xml = datastream_as_(:xml, :except_node => :unit_attributes)
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, xml)
    end

    it "should handle missing timestamps" do
      xml = datastream_as_(:xml, :except_node => :timestamps)
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, xml)
    end

    it "should capture all datapoints" do
      xml = datastream_as_(:xml)
      datastream = Cosm::Datastream.new(xml)
      datastream.datapoints.size.should == 3
    end

    it "should raise exception if passed xml containing more than one datastream" do
      xml = feed_as_(:xml)
      expect {
        Cosm::Datastream.new(xml)
      }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
    end

    it "should raise exception if passed xml without any datastreams" do
      xml = <<-XML
<?xml version="1.0" encoding="UTF-8"?> 
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
  <environment id="504" creator="http://appdev.loc:3000/users/occaecati"> 
  </environment> 
</eeml>
XML

      expect {
        Cosm::Datastream.new(xml)
      }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
    end
  end

  context "5 (used by API v1)" do
    it "should convert into attributes hash" do
      xml = datastream_as_(:xml, :version => "5")
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, xml)
    end

    it "should convert into attributes hash even when no version attribute if correct xmlns" do
      xml = datastream_as_(:xml, :version => "5", :omit_version => true)
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, datastream_as_(:xml, :version => "5"))
    end

    it "should handle blank tags" do
      xml = datastream_as_(:xml, :version => "5", :except_node => :tag)
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, xml)
    end

    it "should handle blank units" do
      xml = datastream_as_(:xml, :version => "5", :except_node => :unit)
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, xml)
    end

    it "should handle missing unit attributes" do
      xml = datastream_as_(:xml, :version => "5", :except_node => :unit_attributes)
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, xml)
    end

    it "should handle missing value attributes" do
      xml = datastream_as_(:xml, :version => "5", :except_node => :value_attributes)
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, xml)
    end

    it "should handle missing timestamps" do
      xml = datastream_as_(:xml, :version => "5", :except_node => :timestamps)
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, xml)
    end

    it "should raise exception if passed xml containing more than one datastream" do
      xml = feed_as_(:xml, :version => "5")
      expect {
        Cosm::Datastream.new(xml)
      }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
    end

    it "should raise exception if passed xml without any datastreams" do
      xml = <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="5" xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://appdev.loc:3000/users/occaecati"> 
  </environment> 
</eeml>
XML

      expect {
        Cosm::Datastream.new(xml)
      }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
    end
  end

  it "should raise exception if passed garbage as XML" do
    expect {
      Cosm::Datastream.new("This is not xml", :v2, :xml)
    }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
  end

  it "should handle being passed xml containing datapoints with no timestamp" do
    xml = <<-XML
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
  <environment>
    <data>
      <datapoints>
        <value at="2010-05-20T11:01:43Z">294</value>
        <value>295</value>
        <value at="2010-05-20T11:01:45Z">296</value>
        <value at="2010-05-20T11:01:46Z">297</value>
      </datapoints>
    </data>
  </environment>
</eeml>
XML

    expect {
      Cosm::Datastream.new(xml)
    }.to_not raise_error
  end
end

