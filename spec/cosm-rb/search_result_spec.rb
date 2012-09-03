require 'spec_helper'

class CustomPachubeFeed < Cosm::Feed
end

describe Cosm::SearchResult do

  it "should have a constant that defines the allowed keys" do
    Cosm::SearchResult::ALLOWED_KEYS.should == %w(totalResults startIndex itemsPerPage results)
  end


  context "attr accessors" do
    before(:each) do
      @search_result = Cosm::SearchResult.new(:results => [feed_as_(:json), feed_as_(:hash)])
    end

    describe "setting whitelisted fields" do
      Cosm::SearchResult::ALLOWED_KEYS.each do |key|
        it "##{key}=" do
          lambda {
            @search_result.send("#{key}=", key)
          }.should_not raise_error
        end
      end
    end

    describe "getting whitelisted fields" do
      Cosm::SearchResult::ALLOWED_KEYS.each do |key|
        it "##{key}" do
          lambda {
            @search_result.send(key)
          }.should_not raise_error
        end
      end
    end

    describe "setting non-whitelisted keys" do
      it "should not be possible to set non-whitelisted fields" do
        lambda {
          @search_result.something_bogus = 'whatevs'
        }.should raise_error
      end

      it "should not be possible to get non-whitelisted fields" do
        lambda {
          @search_result.something_bogus
        }.should raise_error
      end
    end
  end

  describe "#initialize" do
    it "should create a blank slate when passed no arguments" do
      search_result = Cosm::SearchResult.new
      Cosm::SearchResult::ALLOWED_KEYS.each do |attr|
        search_result.attributes[attr.to_sym].should be_nil
      end
    end

    it "should accept a hash of attributes" do
      search_result = Cosm::SearchResult.new("totalResults" => 1000, "results" => [feed_as_(:hash)])
      search_result.totalResults.should == 1000
      search_result.results.length.should == 1
    end

    it "should accept json" do
      search_result = Cosm::SearchResult.new(search_result_as_(:json))
      search_result.totalResults.should == "10000"
      search_result.itemsPerPage.should == "100"
      search_result.startIndex.should == "0"
      search_result.results.length.should == 1
    end

    it "should accept json with no datastreams within the feeds" do
      json = %Q(
        {\"totalResults\":33,\"startIndex\":0,\"results\":[{\"status\":\"frozen\",\"version\":\"1.0.0\",\"updated\":\"2011-05-19T09:50:39.940513Z\",\"title\":\"No map\",\"private\":\"false\",\"feed\":\"http://api.appdev.loc/v2/feeds/79.json\",\"id\":79,\"creator\":\"http://appdev.loc/users/lebreeze\"},{\"status\":\"frozen\",\"location\":{\"lon\":18.28125,\"lat\":28.3043806829628,\"domain\":\"physical\"},\"version\":\"1.0.0\",\"description\":\"Description\",\"updated\":\"2011-05-18T13:25:02.112395Z\",\"title\":\"Title\",\"private\":\"false\",\"feed\":\"http://api.appdev.loc/v2/feeds/78.json\",\"id\":78,\"creator\":\"http://appdev.loc/users/lebreeze\"},{\"status\":\"frozen\",\"location\":{\"exposure\":\"outdoor\",\"domain\":\"physical\",\"disposition\":\"mobile\"},\"version\":\"1.0.0\",\"updated\":\"2011-05-04T12:12:07.352590Z\",\"title\":\"nope\",\"private\":\"false\",\"feed\":\"http://api.appdev.loc/v2/feeds/77.json\",\"id\":77,\"creator\":\"http://appdev.loc/users/lebreeze\"}],\"itemsPerPage\":3}
)
      search_result = Cosm::SearchResult.new(json)
      search_result.results.length.should == 3
    end
  end

  describe "#attributes" do
    it "should return a hash of search result properties" do
      attrs = {}
      Cosm::SearchResult::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["results"] = [Cosm::Feed.new({"id" => "ein"})]
      search_result = Cosm::SearchResult.new(attrs)

      search_result.attributes.should == attrs
    end

    it "should not return nil values" do
      attrs = {}
      Cosm::SearchResult::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["totalResults"] = nil
      search_result = Cosm::Feed.new(attrs)

      search_result.attributes.should_not include("totalResults")
    end
  end

  describe "#attributes=" do
    it "should accept and save a hash of feed properties" do
      search_result = Cosm::SearchResult.new({})

      attrs = {}
      Cosm::SearchResult::ALLOWED_KEYS.each do |key|
        value = "key #{rand(1000)}"
        attrs[key] = value
        search_result.should_receive("#{key}=").with(value)
      end
      search_result.attributes=(attrs)
    end
  end

  context "associated feeds" do

    describe "#results" do
      it "should return an array of feeds" do
        feeds = [Cosm::Feed.new(feed_as_(:hash))]
        attrs = {"results" => feeds}
        search_result = Cosm::SearchResult.new(attrs)
        search_result.results.each do |env|
          env.should be_kind_of(Cosm::Feed)
        end
      end


      it "should allow overriding the feed class to use" do
        Cosm::SearchResult.class_eval("@@feed_class = CustomPachubeFeed")
        feeds = [feed_as_(:hash)]
        attrs = {"results" => feeds}
        search_result = Cosm::SearchResult.new(attrs)
        search_result.results.each do |env|
          env.should be_kind_of(CustomPachubeFeed)
        end
        Cosm::SearchResult.class_eval("@@feed_class = Cosm::Feed")
      end
    end

    describe "#results=" do
      before(:each) do
        @search_result = Cosm::SearchResult.new({})
      end

      it "should return [] if not an array" do
        @search_result.results = "kittens"
        @search_result.results.should be_empty
      end

      it "should accept an array of feeds and hashes and store an array of datastreams" do
        new_feed1 = Cosm::Feed.new(feed_as_(:hash))
        new_feed2 = Cosm::Feed.new(feed_as_(:hash))
        Cosm::Feed.should_receive(:new).with(feed_as_(:hash)).and_return(new_feed2)

        feeds = [new_feed1, feed_as_(:hash)]
        @search_result.results = feeds
        @search_result.results.length.should == 2
        @search_result.results.should include(new_feed1)
        @search_result.results.should include(new_feed2)
      end

      it "should accept an array of feeds and store an array of feeds" do
        feeds = [Cosm::Feed.new(feed_as_(:hash))]
        @search_result.results = feeds
        @search_result.results.should == feeds
      end

      it "should accept an array of hashes and store an array of feeds" do
        new_feed = Cosm::Feed.new(feed_as_(:hash))
        Cosm::Feed.should_receive(:new).with(feed_as_(:hash)).and_return(new_feed)

        feeds_hash = [feed_as_(:hash)]
        @search_result.results = feeds_hash
        @search_result.results.should == [new_feed]
      end
    end

  end

  # Provided by Cosm::Templates::SearchResultDefaults
  describe "#generate_json" do
    it "should take a version and generate the appropriate template" do
      search_result = Cosm::SearchResult.new({"totalResults" => 100, "itemsPerPage" => 12, :results => []})
      search_result.generate_json("1.0.0").should == {:totalResults => 100, :itemsPerPage => 12}
    end
  end

  describe "#to_xml" do
    it "should call the xml generator with default version" do
      search_result = Cosm::SearchResult.new({})
      search_result.should_receive(:generate_xml).with("0.5.1").and_return("<xml></xml>")
      search_result.to_xml.should == "<xml></xml>"
    end

    it "should accept optional xml version" do
      version = "5"
      search_result = Cosm::SearchResult.new({})
      search_result.should_receive(:generate_xml).with(version).and_return("<xml></xml>")
      search_result.to_xml(:version => version).should == "<xml></xml>"
    end
  end

  describe "#as_json" do
    it "should call the json generator with default version" do
      search_result = Cosm::SearchResult.new({})
      search_result.should_receive(:generate_json).with("1.0.0").and_return({"title" => "Feed"})
      search_result.as_json.should == {"title" => "Feed"}
    end

    it "should accept optional json version" do
      version = "0.6-alpha"
      search_result = Cosm::SearchResult.new({})
      search_result.should_receive(:generate_json).with(version).and_return({"title" => "Feed"})
      search_result.as_json(:version => version).should == {"title" => "Feed"}
    end
  end

  describe "#to_json" do
    it "should call #as_json" do
      search_result_hash = {"totalResults" => 100}
      search_result = Cosm::SearchResult.new(search_result_hash)
      search_result.should_receive(:as_json).with({})
      search_result.to_json
    end

    it "should pass options through to #as_json" do
      search_result_hash = {"totalResults" => 100}
      search_result = Cosm::SearchResult.new(search_result_hash)
      search_result.should_receive(:as_json).with({:crazy => "options"})
      search_result.to_json({:crazy => "options"})
    end

    it "should generate feeds" do
      search_result = Cosm::SearchResult.new("results" => [feed_as_('hash')])
      search_result.results = feed_as_(:hash)
      MultiJson.load(search_result.to_json)["results"].should_not be_nil
    end

    it "should pass the output of #as_json to yajl" do
      search_result_hash = {"totalResults" => 100}
      search_result = Cosm::SearchResult.new(search_result_hash)
      search_result.should_receive(:as_json).and_return({:awesome => "hash"})
      MultiJson.should_receive(:dump).with({:awesome => "hash"})
      search_result.to_json
    end
  end


end

