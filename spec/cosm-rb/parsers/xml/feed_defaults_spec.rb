require 'spec_helper'

describe "default feed xml parser" do
  context "0.5.1 (used by API v2)" do
    it "should convert into attributes hash" do
      @xml = feed_as_(:xml)
      Cosm::Feed.new(@xml).should fully_represent_feed(:xml, @xml)
    end

    it "should handle blank location" do
      @xml = feed_as_(:xml, :except_node => :location)
      Cosm::Feed.new(@xml).should fully_represent_feed(:xml, @xml)
    end

    it "should handle blank units" do
      @xml = feed_as_(:xml, :except_node => :unit)
      Cosm::Feed.new(@xml).should fully_represent_feed(:xml, @xml)
    end

    it "should handle missing unit attributes" do
      @xml = feed_as_(:xml, :except_node => :unit_attributes)
      Cosm::Feed.new(@xml).should fully_represent_feed(:xml, @xml)
    end

    it "should handle blank tags" do
      @xml = feed_as_(:xml, :except_node => :tag)
      Cosm::Feed.new(@xml).should fully_represent_feed(:xml, @xml)
    end

    it "should handle present but empty tags" do
      xml = <<-EOXML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd">
  <environment>
    <title>ohai</title>
    <tag></tag>
    <data id="123">
      <tag></tag>
    </data>
  </environment>
</eeml>
EOXML

      feed = Cosm::Feed.new(xml)
      feed.tags.should == ""
      feed.datastreams.first.tags.should == ""
    end

    it "should gracefully handle 0.5.1 xml missing the base environment node" do
      xml = <<-EOXML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd">
  <title>ohai</title>
</eeml>
EOXML
      expect {
        Cosm::Feed.new(xml)
      }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
    end

    it "should handle datastream with no current_value" do
      xml = <<-EOXML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://test.host/users/fred"> 
    <title>Cosm Office environment</title> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
    </data>
  </environment>
</eeml>
EOXML

      feed = Cosm::Feed.new(xml)
      feed.datastreams.size.should == 1
      feed.datastreams.first.tags.should == "freakin lasers,humidity,Temperature"
    end
  end

  context "5 (used by API v1)" do
    it "should convert into attributes hash" do
      @xml = feed_as_(:xml, :version => "5")
      Cosm::Feed.new(@xml).should fully_represent_feed(:xml, @xml)
    end

    it "should handle blank tags" do
      @xml = feed_as_(:xml, :version => "5", :except_node => :tag)
      Cosm::Feed.new(@xml).should fully_represent_feed(:xml, @xml)
    end

    it "should handle blank location" do
      @xml = feed_as_(:xml, :version => "5", :except_node => :location)
      Cosm::Feed.new(@xml).should fully_represent_feed(:xml, @xml)
    end

    it "should handle blank units" do
      @xml = feed_as_(:xml, :version => "5", :except_node => :unit)
      Cosm::Feed.new(@xml).should fully_represent_feed(:xml, @xml)
    end

    it "should handle missing unit attributes" do
      @xml = feed_as_(:xml, :version => "5", :except_node => :unit_attributes)
      Cosm::Feed.new(@xml).should fully_represent_feed(:xml, @xml)
    end

    it "should handle missing value attributes" do
      @xml = feed_as_(:xml, :version => "5", :except_node => :value_attributes)
      feed = Cosm::Feed.new(@xml)
      Cosm::Feed.new(@xml).should fully_represent_feed(:xml, @xml)
    end
    
    it "should handle present but empty tags" do
      xml = <<-EOXML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="5" xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
  <environment>
    <title>ohai</title>
    <data id="123">
      <tag></tag>
    </data>
  </environment>
</eeml>
EOXML

      feed = Cosm::Feed.new(xml)
      feed.datastreams.first.tags.should == ""
    end

    it "should gracefully handle 5 xml missing the base environment node" do
      xml = <<-EOXML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="5" xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
  <title>ohai</title>
</eeml>
EOXML
      expect {
        Cosm::Feed.new(xml)
      }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
    end

    it "should gracefully handle our oddly whitespaced real example" do
      xml = <<-EOXML
<?xml version="1.0" encoding="UTF-8"?>
<eeml version="5" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.eeml.org/xsd/005" xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd">
  <environment>
    <data id="4773635294300160">
      <tag>
        10.F59894010800</tag>
      <tag>
        Living Room, S wall</tag>
      <value>
        24.1875</value>
      <unit type="derivedSI">
        celsius</unit>
    </data>
  </environment>
</eeml>
EOXML
      feed = Cosm::Feed.new(xml)

      datastream = feed.datastreams.first
      datastream.tags.should == "10.F59894010800,\"Living Room, S wall\""
      datastream.current_value.should == "24.1875"
      datastream.unit_label.should == "celsius"
    end
  end
end

