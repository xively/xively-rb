require 'spec_helper'

describe "default feed xml templates" do
  before(:each) do
    @feed = Xively::Feed.new(feed_as_(:hash))
    @search_result = Xively::SearchResult.new("totalResults" => 198, "startIndex" => 4, "itemsPerPage" => 15, "results" => [@feed])
  end

  context "0.5.1 (used by API V2)" do
    it "should be the default" do
      @search_result.should_receive(:generate_xml).with("0.5.1")
      @search_result.to_xml
    end

    it "should represent Pachube EEML" do
      xml = Nokogiri.parse(@search_result.generate_xml("0.5.1"))
      xml.at_xpath("//opensearch:totalResults").content.should == "198"
      xml.at_xpath("//opensearch:startIndex").content.should == "4"
      xml.at_xpath("//opensearch:itemsPerPage").content.should == "15"
      xml.should describe_eeml_for_version("0.5.1")
      xml.xpath("//xmlns:environment").should_not be_empty
      xml.xpath("//xmlns:environment").each do |feed_xml|
        feed_xml.should contain_feed_eeml_for_version("0.5.1")
      end
    end
  end

  context "5 (used by API V1)" do

    it "should represent Pachube EEML" do
      xml = Nokogiri.parse(@search_result.generate_xml("5"))
      xml.at_xpath("//opensearch:totalResults").content.should == "198"
      xml.at_xpath("//opensearch:startIndex").content.should == "4"
      xml.at_xpath("//opensearch:itemsPerPage").content.should == "15"
      xml.should describe_eeml_for_version("5")
      xml.xpath("//xmlns:environment").should_not be_empty
      xml.xpath("//xmlns:environment").each do |feed_xml|
        feed_xml.should contain_feed_eeml_for_version("5")
      end
    end
  end

end

