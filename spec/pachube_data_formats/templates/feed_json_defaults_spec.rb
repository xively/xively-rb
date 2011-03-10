require File.dirname(__FILE__) + '/../../spec_helper'

describe "default feed json templates" do
  before(:each) do
    @feed = PachubeDataFormats::Feed.new(feed_as_(:hash))
  end

  context "1.0.0" do
    it "should be the default" do
      @feed.generate_json("1.0.0").should == @feed.as_json
    end

    it "should represent Pachube JSON (used by API v2)" do
      json = @feed.generate_json("1.0.0")
      json[:id].should == @feed.id
      json[:version].should == "1.0.0"
      json[:title].should == "Pachube Office Environment"
      json[:private].should == "false"
      json[:icon].should == "http://pachube.com/logo.png"
      json[:website].should == "http://pachube.com"
      json[:tags].should == ["aardvark", "kittens", "sofa"]
      json[:description].should == "Sensors in Pachube.com's headquarters."
      json[:feed].should == "http://test.host/testfeed.html?random=890299&rand2=91.json"
      json[:status].should == "live"
      json[:updated].should == "2011-01-02T00:00:00.000000+00:00"
      json[:email].should == "abc@example.com"
      json[:creator].should == "http://pachube.com/users/skeletor"
      json[:location][:disposition].should == "fixed"
      json[:location][:name].should == "office"
      json[:location][:exposure].should == "indoor"
      json[:location][:domain].should == "physical"
      json[:location][:ele].should == "23.0"
      json[:location][:lat].should == 51.5235375648154
      json[:location][:lon].should == -0.0807666778564453
      json[:datastreams].should have(7).things
      json[:datastreams].each do |ds|
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
        }.delete_if{ |k,v|v.nil? || v.blank? } if ds[:unit]
        ds[:datapoints].each do |dp|
          datapoint = datastream.datapoints.detect {|point| point.at.iso8601(6) == dp[:at]}
          dp[:value].should == datapoint.value
        end if ds[:datapoints]
      end
    end

    it "should ignore datastream datapoints if empty" do
      @feed.datastreams.each do |ds|
        ds.datapoints = []
      end
      json = @feed.generate_json("1.0.0")
      json[:datastreams].each do |ds|
        ds[:datapoints].should be_nil
      end
    end

    it "should ignore datastream tags if nil" do
      @feed.datastreams.each do |ds|
        ds.tags = nil
      end
      json = @feed.generate_json("1.0.0")
      json[:datastreams].each do |ds|
        datastream = @feed.datastreams.detect{|stream| stream.id == ds[:id]}
        datastream.tags.should be_nil
      end
    end

    it "should ignore updated if nil" do
      @feed.updated = nil
      json = @feed.generate_json("1.0.0")
      json[:updated].should be_nil
    end

    it "should ignore tags if nil" do
      @feed.tags = nil
      json = @feed.generate_json("1.0.0")
      json[:tags].should be_nil
    end

    it "should ignore location if all elements are nil" do
      @feed.location_name = nil
      @feed.location_disposition = nil
      @feed.location_lat = nil
      @feed.location_lon = nil
      @feed.location_exposure = nil
      @feed.location_ele = nil
      @feed.location_domain = nil
      json = @feed.generate_json("1.0.0")
      json[:location].should be_nil
    end

  end

  context "0.6-alpha" do

    it "should represent Pachube JSON (used by API v1)" do
      json = @feed.generate_json("0.6-alpha")
      json[:id].should == @feed.id
      json[:version].should == "0.6-alpha"
      json[:title].should == "Pachube Office Environment"
      json[:private].should be_nil
      json[:icon].should == "http://pachube.com/logo.png"
      json[:website].should == "http://pachube.com"
      json[:tags].should be_nil
      json[:description].should == "Sensors in Pachube.com's headquarters."
      json[:feed].should == "http://test.host/testfeed.html?random=890299&rand2=91.json"
      json[:status].should == "live"
      json[:updated].should == "2011-01-02T00:00:00.000000+00:00"
      json[:email].should == "abc@example.com"
      json[:location][:disposition].should == "fixed"
      json[:location][:name].should == "office"
      json[:location][:exposure].should == "indoor"
      json[:location][:domain].should == "physical"
      json[:location][:ele].should == "23.0"
      json[:location][:lat].should == 51.5235375648154
      json[:location][:lon].should == -0.0807666778564453
      json[:datastreams].should have(7).things
      json[:datastreams].each do |ds|
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
        }.delete_if{ |k,v|v.nil? || v.blank? } if ds[:unit]
      end
    end

    it "should ignore datastream units if blank (0.6-alpha)" do
      @feed.datastreams.each do |ds|
        ds.unit_label = ''
        ds.unit_symbol = ''
        ds.unit_type = ''
      end
      json = @feed.generate_json("0.6-alpha")
      json[:datastreams].each do |ds|
        ds[:unit].should be_nil
      end
    end

    it "should ignore datastream units if blank (1.0.0)" do
      @feed.datastreams.each do |ds|
        ds.unit_label = ''
        ds.unit_symbol = ''
        ds.unit_type = ''
      end
      json = @feed.generate_json("1.0.0")
      json[:datastreams].each do |ds|
        ds[:unit].should be_nil
      end
    end

    it "should ignore datastream units if nil (1.0.0)" do
      @feed.datastreams.each do |ds|
        ds.unit_label = nil
        ds.unit_symbol = nil
        ds.unit_type = nil
      end
      json = @feed.generate_json("1.0.0")
      json[:datastreams].each do |ds|
        ds[:unit].should be_nil
      end
    end

    it "should ignore datastream units if nil (0.6-alpha)" do
      @feed.datastreams.each do |ds|
        ds.unit_label = nil
        ds.unit_symbol = nil
        ds.unit_type = nil
      end
      json = @feed.generate_json("0.6-alpha")
      json[:datastreams].each do |ds|
        ds[:unit].should be_nil
      end
    end

    it "should ignore datastream tags if blank (0.6-alpha)" do
      @feed.datastreams.each do |ds|
        ds.tags = ""
      end
      json = @feed.generate_json("0.6-alpha")
      json[:datastreams].each do |ds|
        ds[:tags].should be_nil
      end
    end

    it "should ignore datastream tags if blank (1.0.0)" do
      @feed.datastreams.each do |ds|
        ds.tags = ""
      end
      json = @feed.generate_json("1.0.0")
      json[:datastreams].each do |ds|
        ds[:tags].should be_nil
      end
    end

    it "should ignore datastream tags if nil (1.0.0)" do
      @feed.datastreams.each do |ds|
        ds.tags = nil
      end
      json = @feed.generate_json("1.0.0")
      json[:datastreams].each do |ds|
        ds[:tags].should be_nil
      end
    end

    it "should ignore datastream tags if nil (0.6-alpha)" do
      @feed.datastreams.each do |ds|
        ds.tags = nil
      end
      json = @feed.generate_json("0.6-alpha")
      json[:datastreams].each do |ds|
        ds[:tags].should be_nil
      end
    end

    it "should ignore datastream value fields if nil (0.6-alpha)" do
      @feed.datastreams.each do |ds|
        ds.min_value = nil
      end
      json = @feed.generate_json("0.6-alpha")
      json[:datastreams].each do |ds|
        ds[:values].first[:min_value].should be_nil
      end
    end

    it "should ignore datastream value fields if blank (0.6-alpha)" do
      @feed.datastreams.each do |ds|
        ds.min_value = ""
      end
      json = @feed.generate_json("0.6-alpha")
      json[:datastreams].each do |ds|
        ds[:values].first[:min_value].should be_nil
      end
    end

    it "should ignore tags if blank (1.0.0)" do
      @feed.tags = ""
      json = @feed.generate_json("1.0.0")
      json[:tags].should be_nil
    end

    it "should ignore tags if blank (0.6-alpha)" do
      @feed.tags = ""
      json = @feed.generate_json("0.6-alpha")
      json[:tags].should be_nil
    end

    it "should ignore tags if nil (1.0.0)" do
      @feed.tags = nil
      json = @feed.generate_json("1.0.0")
      json[:tags].should be_nil
    end

    it "should ignore tags if nil" do
      @feed.tags = nil
      json = @feed.generate_json("0.6-alpha")
      json[:tags].should be_nil
    end

    it "should ignore nil location elements (1.0.0)" do
      @feed.location_disposition = nil
      @feed.location_ele = nil
      json = @feed.generate_json("1.0.0")
      json[:location][:disposition].should be_nil
      json[:location][:ele].should be_nil
    end

    it "should ignore nil location elements (0.6-alpha)" do
      @feed.location_disposition = nil
      @feed.location_ele = nil
      json = @feed.generate_json("0.6-alpha")
      json[:location][:disposition].should be_nil
      json[:location][:ele].should be_nil
    end

    it "should ignore blank location elements (1.0.0)" do
      @feed.location_disposition = ""
      @feed.location_ele = ""
      json = @feed.generate_json("1.0.0")
      json[:location][:disposition].should be_nil
      json[:location][:ele].should be_nil
    end

    it "should ignore blank location elements (0.6-alpha)" do
      @feed.location_disposition = ""
      @feed.location_ele = ""
      json = @feed.generate_json("0.6-alpha")
      json[:location][:disposition].should be_nil
      json[:location][:ele].should be_nil
    end

    it "should ignore location if all elements are nil (1.0.0)" do
      @feed.location_name = nil
      @feed.location_disposition = nil
      @feed.location_lat = nil
      @feed.location_lon = nil
      @feed.location_exposure = nil
      @feed.location_ele = nil
      @feed.location_domain = nil
      json = @feed.generate_json("1.0.0")
      json[:location].should be_nil
    end

    it "should ignore location if all elements are nil (0.6-alpha)" do
      @feed.location_name = nil
      @feed.location_disposition = nil
      @feed.location_lat = nil
      @feed.location_lon = nil
      @feed.location_exposure = nil
      @feed.location_ele = nil
      @feed.location_domain = nil
      json = @feed.generate_json("0.6-alpha")
      json[:location].should be_nil
    end
  end
end

