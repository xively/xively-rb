require 'spec_helper'

describe "default feed json templates" do
  before(:each) do
    @feed = Cosm::Feed.new(feed_as_(:hash))
  end

  context "1.0.0" do
    it "should be the default" do
      @feed.generate_json("1.0.0").should == @feed.as_json
    end

    it "should represent Cosm JSON (used by API v2)" do
      json = @feed.generate_json("1.0.0")
      json[:id].should == @feed.id
      json[:version].should == "1.0.0"
      json[:title].should == "Cosm Office Environment"
      json[:private].should == "false"
      json[:icon].should == "http://cosm.com/logo.png"
      json[:website].should == "http://cosm.com"
      json[:tags].should == ["aardvark", "kittens", "sofa"]
      json[:description].should == "Sensors in cosm.com's headquarters."
      json[:feed].should == "http://test.host/testfeed.html?random=890299&rand2=91.json"
      json[:auto_feed_url].should == "http://test.host2/testfeed.xml?q=something"
      json[:user][:login].should == "skeletor"
      json[:status].should == "live"
      json[:updated].should == "2011-01-02T00:00:00.000000+00:00"
      json[:created].should == "2011-01-01T00:00:00.000000+00:00"
      json[:email].should == "abc@example.com"
      json[:creator].should == "http://cosm.com/users/skeletor"
      json[:product_id].should == "product_id"
      json[:device_serial].should == "device_serial"
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

    it "should blank feed if blank" do
      @feed.feed = ''
      json = @feed.generate_json("1.0.0")
      json[:feed].should be_blank
    end

    it "should blank feed if nil" do
      @feed.feed = nil
      json = @feed.generate_json("1.0.0")
      json[:feed].should be_blank
    end

    it "should ignore updated if nil" do
      @feed.updated = nil
      json = @feed.generate_json("1.0.0")
      json[:updated].should be_nil
    end

    it "should ignore updated if nil" do
      @feed.created = nil
      json = @feed.generate_json("1.0.0")
      json[:created].should be_nil
    end

    it "should ignore tags if nil" do
      @feed.tags = nil
      json = @feed.generate_json("1.0.0")
      json[:tags].should be_nil
    end

    it "should handle tags if an array" do
      @feed.tags = %w(b a c)
      json = @feed.generate_json("1.0.0")
      json[:tags].should == %w(a b c)
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

    it "should ignore datastream units if blank" do
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

    it "should ignore datastream units if nil" do
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

    it "should ignore blank location elements" do
      @feed.location_disposition = ""
      @feed.location_ele = ""
      json = @feed.generate_json("1.0.0")
      json[:location][:disposition].should be_nil
      json[:location][:ele].should be_nil
    end

    it "should ignore nil location elements" do
      @feed.location_disposition = nil
      @feed.location_ele = nil
      json = @feed.generate_json("1.0.0")
      json[:location][:disposition].should be_nil
      json[:location][:ele].should be_nil
    end

    it "should ignore location_waypoints if it is nil" do
      @feed.location_disposition = 'mobile'
      @feed.location_waypoints = nil
      json = @feed.generate_json("1.0.0")
      json[:location][:disposition].should == 'mobile'
      json[:location][:waypoints].should be_nil
    end

    it "should use location_waypoints if it is set" do
      @feed.location_disposition = 'mobile'
      @feed.location_waypoints = [
        {:at => Time.parse('2012-01-01 12:00:00'), :lat => 1.0, :lon => 1.1, :ele => "1.2"},
        {:at => Time.parse('2012-01-01 13:00:00'), :lat => 2.0, :lon => 2.1, :ele => "2.2"}
      ]
      json = @feed.generate_json("1.0.0")
      json[:location][:disposition].should == 'mobile'
      json[:location][:waypoints].should == [
        {:at => Time.parse('2012-01-01 12:00:00').iso8601(6), :lat => 1.0, :lon => 1.1, :ele => "1.2"},
        {:at => Time.parse('2012-01-01 13:00:00').iso8601(6), :lat => 2.0, :lon => 2.1, :ele => "2.2"}
      ]
    end

    it "should ignore datastream tags if blank" do
      @feed.datastreams.each do |ds|
        ds.tags = ""
      end
      json = @feed.generate_json("1.0.0")
      json[:datastreams].each do |ds|
        ds[:tags].should be_nil
      end
    end

    it "should ignore datastream tags if nil" do
      @feed.datastreams.each do |ds|
        ds.tags = nil
      end
      json = @feed.generate_json("1.0.0")
      json[:datastreams].each do |ds|
        ds[:tags].should be_nil
      end
    end

    it "should ignore tags if blank" do
      @feed.tags = ""
      json = @feed.generate_json("1.0.0")
      json[:tags].should be_nil
    end

    it "should ignore tags if nil" do
      @feed.tags = nil
      json = @feed.generate_json("1.0.0")
      json[:tags].should be_nil
    end

    it "should include empty stuff if we pass :include_blank" do
      @feed.description = ''
      @feed.location_ele = ''
      json = @feed.generate_json("1.0.0", :include_blank => true)
      json[:description].should == ''
      json[:location][:ele].should == ''
    end
  end

  context "0.6-alpha" do

    it "should represent Cosm JSON (used by API v1)" do
      json = @feed.generate_json("0.6-alpha")
      json[:id].should == @feed.id
      json[:version].should == "0.6-alpha"
      json[:title].should == "Cosm Office Environment"
      json[:private].should be_nil
      json[:icon].should == "http://cosm.com/logo.png"
      json[:website].should == "http://cosm.com"
      json[:tags].should be_nil
      json[:description].should == "Sensors in cosm.com's headquarters."
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

    it "should ignore datastream units if blank" do
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

    it "should ignore datastream units if nil" do
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

    it "should ignore datastream tags if blank" do
      @feed.datastreams.each do |ds|
        ds.tags = ""
      end
      json = @feed.generate_json("0.6-alpha")
      json[:datastreams].each do |ds|
        ds[:tags].should be_nil
      end
    end


    it "should ignore datastream tags if nil" do
      @feed.datastreams.each do |ds|
        ds.tags = nil
      end
      json = @feed.generate_json("0.6-alpha")
      json[:datastreams].each do |ds|
        ds[:tags].should be_nil
      end
    end

    it "should ignore datastream value fields if nil" do
      @feed.datastreams.each do |ds|
        ds.min_value = nil
      end
      json = @feed.generate_json("0.6-alpha")
      json[:datastreams].each do |ds|
        ds[:values].first[:min_value].should be_nil
      end
    end

    it "should ignore datastream value fields if blank" do
      @feed.datastreams.each do |ds|
        ds.min_value = ""
      end
      json = @feed.generate_json("0.6-alpha")
      json[:datastreams].each do |ds|
        ds[:values].first[:min_value].should be_nil
      end
    end
    it "should ignore tags if blank" do
      @feed.tags = ""
      json = @feed.generate_json("0.6-alpha")
      json[:tags].should be_nil
    end


    it "should ignore tags if nil" do
      @feed.tags = nil
      json = @feed.generate_json("0.6-alpha")
      json[:tags].should be_nil
    end

    it "should ignore nil location elements" do
      @feed.location_disposition = nil
      @feed.location_ele = nil
      json = @feed.generate_json("0.6-alpha")
      json[:location][:disposition].should be_nil
      json[:location][:ele].should be_nil
    end


    it "should ignore blank location elements" do
      @feed.location_disposition = ""
      @feed.location_ele = ""
      json = @feed.generate_json("0.6-alpha")
      json[:location][:disposition].should be_nil
      json[:location][:ele].should be_nil
    end


    it "should ignore location if all elements are nil" do
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

    it "should include empty stuff if we pass :include_blank" do
      @feed.description = ''
      @feed.location_ele = ''
      json = @feed.generate_json("0.6-alpha", :include_blank => true)
      json[:description].should == ''
      json[:location][:ele].should == ''
    end
  end
end

