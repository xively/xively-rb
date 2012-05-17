require 'spec_helper'

describe "default datastream json parser" do
  before(:each) do
    @datastream = Cosm::Datastream.new(datastream_as_(:json))
  end

  it "should default to v1 API if no version is sent" do
    @json = datastream_as_(:json, :version => "0.6-alpha", :except => [:version])
    attributes = {}
    lambda {attributes = @datastream.from_json(@json)}.should_not raise_error
    json = JSON.parse(@json)
    attributes["id"].should == json["id"]
    attributes["updated"].should == json["values"].first["recorded_at"]
    attributes["current_value"].should == json["values"].first["value"]
    attributes["max_value"].should == json["values"].first["max_value"]
    attributes["min_value"].should == json["values"].first["min_value"]
    attributes["tags"].should == json["tags"].join(',')
    attributes["unit_type"].should == json["unit"]["type"]
    attributes["unit_label"].should == json["unit"]["label"]
    attributes["unit_symbol"].should == json["unit"]["symbol"]
  end

  context "1.0.0 (used by API v2)" do
    it "should convert into attributes hash" do
      @json = datastream_as_(:json)
      attributes = @datastream.from_json(@json)
      json = JSON.parse(@json)
      attributes["id"].should == json["id"]
      attributes["updated"].should == json["at"]
      attributes["current_value"].should == json["current_value"]
      attributes["max_value"].should == json["max_value"]
      attributes["min_value"].should == json["min_value"]
      attributes["tags"].should == json["tags"].join(',')
      attributes["unit_type"].should == json["unit"]["type"]
      attributes["unit_label"].should == json["unit"]["label"]
      attributes["unit_symbol"].should == json["unit"]["symbol"]
      at_least_one_datapoint = false
      attributes["datapoints"].each do |point|
        at_least_one_datapoint = true
        dp = json["datapoints"].detect {|dp| dp["at"] == point["at"]}
        point["value"].should == dp["value"]
        point["at"].should == dp["at"]
      end
      at_least_one_datapoint.should be_true
    end

    it "should handle blank tags" do
      @json = datastream_as_(:json, :except => [:tags])
      lambda {@datastream.from_json(@json)}.should_not raise_error
    end
  end

  context "0.6-alpha (used by API v1)" do

    it "should convert into attributes hash" do
      @json = datastream_as_(:json, :version => "0.6-alpha")
      attributes = @datastream.from_json(@json)
      json = JSON.parse(@json)
      attributes["id"].should == json["id"]
      attributes["updated"].should == json["values"].first["recorded_at"]
      attributes["current_value"].should == json["values"].first["value"]
      attributes["max_value"].should == json["values"].first["max_value"]
      attributes["min_value"].should == json["values"].first["min_value"]
      attributes["tags"].should == json["tags"].join(',')
      attributes["unit_type"].should == json["unit"]["type"]
      attributes["unit_label"].should == json["unit"]["label"]
      attributes["unit_symbol"].should == json["unit"]["symbol"]
    end

    it "should handle blank tags" do
      @json = datastream_as_(:json, :version => "0.6-alpha", :except => [:tags])
      lambda {@datastream.from_json(@json)}.should_not raise_error
    end

    it "should handle blank values" do
      @json = datastream_as_(:json, :version => "0.6-alpha", :except => [:values])
      lambda {@datastream.from_json(@json)}.should_not raise_error
    end
  end

end
