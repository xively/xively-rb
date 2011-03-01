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

    it "should handle a lack of tags" do
      @feed.tags = nil
      lambda {@feed.generate_xml("0.5.1")}.should_not raise_error
    end

  end

  context "5 (used by API V1)" do

    it "should represent Pachube EEML" do
      xml = Nokogiri.parse(@feed.generate_xml("5"))
      xml.should describe_eeml_for_version("5")
      xml.should contain_feed_eeml_for_version("5")
    end

    it "should handle a lack of tags" do
      @feed.tags = nil
      lambda {@feed.generate_xml("5")}.should_not raise_error
    end

  end


end

