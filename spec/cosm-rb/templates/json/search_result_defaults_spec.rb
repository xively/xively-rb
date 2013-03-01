require 'spec_helper'

describe "default search result json templates" do
  before(:each) do
    @search_result = Cosm::SearchResult.new(search_result_as_(:hash))
  end

  context "1.0.0" do
    it "should represent Pachube v2 json for search results" do
      @search_result.results.each do |feed|
        feed.should_receive(:generate_json).with("1.0.0").and_return("feed_100_json")
      end
      @search_result.generate_json("1.0.0").should == {
        :totalResults => "10000",
        :startIndex => "0",
        :itemsPerPage => "100",
        :results => ["feed_100_json"]
      }
    end
  end

  context "0.6-alpha" do
    it "should represent Pachube v1 json for search results" do
      @search_result.results.each do |feed|
        feed.should_receive(:generate_json).with("0.6-alpha").and_return("feed_6_json")
      end
      @search_result.generate_json("0.6-alpha").should == {
        :startIndex => "0",
        :totalResults => "10000",
        :itemsPerPage => "100",
        :results => ["feed_6_json"]
      }
    end
  end
end


