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

    it "should parse xml missing the version attribute, but with the correct 0.5.1 xmlns" do
      xml = feed_as_(:xml, :omit_version => true)
      Cosm::Feed.new(xml).should fully_represent_feed(:xml, feed_as_(:xml))
    end
  end

  context "5 (used by API v1)" do
    it "should convert into attributes hash" do
      @xml = feed_as_(:xml, :version => "5")
      Cosm::Feed.new(@xml).should fully_represent_feed(:xml, @xml)
    end

    it "should convert into attributes hash if missing version attribute, but with correct xmlns" do
      xml = feed_as_(:xml, :version => "5", :omit_version => true)
      Cosm::Feed.new(xml).should fully_represent_feed(:xml, feed_as_(:xml, :version => "5"))
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

  context "garbage input" do
    it "should not propogate nokogiri error for invalid xml" do
      xml = <<-EOXML
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
    <channel>
        <title>Skype Statistics</title>
        <description>Statistics From Skype</description>
        <link>http://www.skype.com/</link>
        <lastBuildDate>Thu, 02 Aug 2012 13:50:01 +0000</lastBuildDate>
        <image>
            <url>http://www.skype.com/i/logos/skype.png</url>
            <title>Skype</title>
            <link>http://www.skype.com/</link>
            <description>Statistics From Skype</description>
        </image>
        <ttl>60</ttl>
        <item>
            <title>Total Skype Downloads</title>
            <link>http://www.skype.com/</link>
            <description>2992280145</description>
            <pubDate>Thu, 02 Aug 2012 13:50:01 +0000</pubDate>
            <guid>Total Skype Downloads Thu, 02 Aug 2012 13:50:01 +0000</guid>
        </item>
        <item>
            <title>Users Online Now</title>
            <link>http://www.skype.com/</link>
            <description>39393244</description>
            <pubDate>Thu, 02 Aug 2012 13:50:01 +0000</pubDate>
            <guid>Users Online Now Thu, 02 Aug 2012 13:50:01 +0000</guid>
        </item>
    </channel>
</rss>
EOXML
      expect {
        Cosm::Feed.new(xml)
      }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
    end
  end

  context "feeds with datapoints" do
    it "should grab all datapoints present in valid xml" do
      xml = <<-XML
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
  <environment>
    <data id="0">
      <datapoints>
        <value at="2010-05-20T11:01:43Z">294</value>
        <value at="2010-05-20T11:01:44Z">295</value>
        <value at="2010-05-20T11:01:45Z">296</value>
        <value at="2010-05-20T11:01:46Z">297</value>
      </datapoints>
    </data>
    <data id="1">
      <current_value at="2010-05-20T11:01:47Z">23</current_value> 
      <datapoints>
        <value at="2010-05-20T11:01:43Z">24</value>
        <value at="2010-05-20T11:01:44Z">25</value>
      </datapoints>
    </data>
  </environment>
</eeml>
XML
      feed = Cosm::Feed.new(xml)
      feed.datastreams.size.should == 2
      feed.datastreams[0].current_value.should == nil
      feed.datastreams[0].datapoints.size.should == 4
      feed.datastreams[0].datapoints.collect { |d| d.value }.should == ["294", "295", "296", "297"]
      feed.datastreams[1].current_value.should == "23"
      feed.datastreams[1].datapoints.size.should == 2
      feed.datastreams[1].datapoints.collect { |d| d.value }.should == ["24", "25"]
    end
  end
end

