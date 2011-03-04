require File.dirname(__FILE__) + '/../../spec_helper'

describe "default feed xml templates" do
  before(:each) do
    @feed = PachubeDataFormats::Feed.new(feed_as_(:hash))
  end

  context "0.5.1 (used by API V2)" do
    it "should be the default" do
      @feed.generate_json("1.0.0").should == @feed.as_json
    end

    it "should represent Pachube EEML" do
      xml = Nokogiri.parse(@feed.generate_xml("0.5.1"))
      xml.should describe_eeml_for_version("0.5.1")
      xml.should contain_feed_eeml_for_version("0.5.1")
    end

    it "should handle a lack of updated" do
      @feed.updated = nil
      lambda {@feed.generate_xml("0.5.1")}.should_not raise_error
    end

    it "should handle a lack of tags" do
      @feed.tags = nil
      lambda {@feed.generate_xml("0.5.1")}.should_not raise_error
    end

    it "should ignore blank min/max values" do
      @feed.datastreams.each do |ds|
        ds.max_value = nil
        ds.min_value = nil
      end
      Nokogiri.parse(@feed.generate_xml("0.5.1")).xpath("//xmlns:max_value").should be_empty
      Nokogiri.parse(@feed.generate_xml("0.5.1")).xpath("//xmlns:min_value").should be_empty
    end

    it "should ignore blank attributes" do
      @feed.datastreams.each do |ds|
        ds.unit_symbol = nil
        ds.unit_label = "Woohoo"
        ds.unit_type = "Type A"
      end
      Nokogiri.parse(@feed.generate_xml("0.5.1")).xpath("//xmlns:unit").each do |unit_node|
        unit_node.attributes["symbol"].should be_nil
      end
    end

    it "should ignore blank units" do
      @feed.datastreams.each do |ds|
        ds.unit_symbol = nil
        ds.unit_label = nil
        ds.unit_type = nil
      end
      Nokogiri.parse(@feed.generate_xml("0.5.1")).xpath("//xmlns:unit").should be_blank
    end

  end

  context "5 (used by API V1)" do

    it "should represent Pachube EEML" do
      xml = Nokogiri.parse(@feed.generate_xml("5"))
      xml.should describe_eeml_for_version("5")
      xml.should contain_feed_eeml_for_version("5")
    end

    it "should handle a lack of updated" do
      @feed.updated = nil
      lambda {@feed.generate_xml("5")}.should_not raise_error
    end

    it "should handle a lack of tags" do
      @feed.tags = nil
      lambda {@feed.generate_xml("5")}.should_not raise_error
    end

    it "should ignore blank attributes" do
      @feed.datastreams.each do |ds|
        ds.max_value = nil
        ds.unit_symbol = nil
        ds.unit_label = "Woohoo"
        ds.unit_type = "Type A"
      end
      Nokogiri.parse(@feed.generate_xml("5")).xpath("//xmlns:unit").each do |unit_node|
        unit_node.attributes["symbol"].should be_nil
      end
      Nokogiri.parse(@feed.generate_xml("5")).xpath("//xmlns:value").each do |value_node|
        value_node.attributes["maxValue"].should be_nil
      end
    end

    it "should ignore blank units" do
      @feed.datastreams.each do |ds|
        ds.unit_symbol = nil
        ds.unit_label = nil
        ds.unit_type = nil
      end
      Nokogiri.parse(@feed.generate_xml("5")).xpath("//xmlns:unit").should be_blank
    end

  end

end

