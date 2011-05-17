require File.dirname(__FILE__) + '/../../../spec_helper'

describe "default search result json parser" do
  describe "json" do
    it "should convert Pachube JSON 1.0.0 (used by API v2) into attributes hash" do
      json = search_result_as_(:json)
      search_result = PachubeDataFormats::SearchResult.new(json)
      search_result.should fully_represent_search_result(:json, json)
    end
  end
end

