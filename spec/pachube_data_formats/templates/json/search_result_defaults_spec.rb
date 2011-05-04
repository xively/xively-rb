require File.dirname(__FILE__) + '/../../../spec_helper'

describe "default feed json templates" do
  before(:each) do
    @feed = PachubeDataFormats::Feed.new(feed_as_(:hash))
    @search_result = PachubeDataFormats::SearchResult.new("totalResults" => 198, "startIndex" => 4, "itemsPerPage" => 15, "results" => [@feed])
  end

  context "1.0.0" do
    it "should be the default" do
      @search_result.generate_json("1.0.0").should == @search_result.as_json
    end

    it "should represent Pachube search result JSON (used by API v2)" do
      json = @search_result.generate_json("1.0.0")
      json[:totalResults].should == 198
      json[:startIndex].should == 4
      json[:itemsPerPage].should == 15
      json[:results].each do |json_feed|
        json_feed[:id].should == @feed.id
        json_feed[:version].should == "1.0.0"
        json_feed[:title].should == "Pachube Office Environment"
        json_feed[:private].should == "false"
        json_feed[:icon].should == "http://pachube.com/logo.png"
        json_feed[:website].should == "http://pachube.com"
        json_feed[:tags].should == ["aardvark", "kittens", "sofa"]
        json_feed[:description].should == "Sensors in Pachube.com's headquarters."
        json_feed[:feed].should == "http://test.host/testfeed.html?random=890299&rand2=91.json"
        json_feed[:status].should == "live"
        json_feed[:updated].should == "2011-01-02T00:00:00.000000+00:00"
        json_feed[:email].should == "abc@example.com"
        json_feed[:creator].should == "http://pachube.com/users/skeletor"
        json_feed[:location][:disposition].should == "fixed"
        json_feed[:location][:name].should == "office"
        json_feed[:location][:exposure].should == "indoor"
        json_feed[:location][:domain].should == "physical"
        json_feed[:location][:ele].should == "23.0"
        json_feed[:location][:lat].should == 51.5235375648154
        json_feed[:location][:lon].should == -0.0807666778564453
        json_feed[:datastreams].should have(7).things
        json_feed[:datastreams].each do |ds|
          datastream = @feed.datastreams.detect{|stream| stream.id == ds[:id]}
          ds[:at].should == datastream.updated.iso8601(6)
          ds[:max_value].should == datastream.max_value.to_s
          ds[:min_value].should == datastream.min_value.to_s
          ds[:current_value].should == datastream.current_value
          ds[:tags].should == datastream.tags.split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase} if datastream.tags
          ds[:unit].should == {
            :label => datastream.unit_label,
            :type => datastream.unit_type,
            :symbol => datastream.unit_symbol
          }.delete_if_nil_value if ds[:unit]
        end
      end
    end
  end

  context "0.6-alpha" do

    it "should represent Pachube JSON (used by API v1)" do
      json = @search_result.generate_json("0.6-alpha")
      json[:totalResults].should == 198
      json[:startIndex].should == 4
      json[:itemsPerPage].should == 15
      json[:results].each do |json_feed|
        json_feed[:id].should == @feed.id
        json_feed[:version].should == "0.6-alpha"
        json_feed[:title].should == "Pachube Office Environment"
        json_feed[:private].should be_nil
        json_feed[:icon].should == "http://pachube.com/logo.png"
        json_feed[:website].should == "http://pachube.com"
        json_feed[:tags].should be_nil
        json_feed[:description].should == "Sensors in Pachube.com's headquarters."
        json_feed[:feed].should == "http://test.host/testfeed.html?random=890299&rand2=91.json"
        json_feed[:status].should == "live"
        json_feed[:updated].should == "2011-01-02T00:00:00.000000+00:00"
        json_feed[:email].should == "abc@example.com"
        json_feed[:location][:disposition].should == "fixed"
        json_feed[:location][:name].should == "office"
        json_feed[:location][:exposure].should == "indoor"
        json_feed[:location][:domain].should == "physical"
        json_feed[:location][:ele].should == "23.0"
        json_feed[:location][:lat].should == 51.5235375648154
        json_feed[:location][:lon].should == -0.0807666778564453
        json_feed[:datastreams].should have(7).things
        json_feed[:datastreams].each do |ds|
          datastream = @feed.datastreams.detect{|stream| stream.id == ds[:id]}
          ds[:values].first[:max_value].should == datastream.max_value.to_s
          ds[:values].first[:min_value].should == datastream.min_value.to_s
          ds[:values].first[:value].should == datastream.current_value
          ds[:values].first[:recorded_at].should == datastream.updated.iso8601
          ds[:tags].should == datastream.tags.split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase} if datastream.tags
          ds[:unit].should == {
            :label => datastream.unit_label,
            :type => datastream.unit_type,
            :symbol => datastream.unit_symbol
          }.delete_if_nil_value if ds[:unit]
        end
      end
    end
  end
end

