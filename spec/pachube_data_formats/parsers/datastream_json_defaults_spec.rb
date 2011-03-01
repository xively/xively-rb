require File.dirname(__FILE__) + '/../../spec_helper'

describe "default datastream json parser" do
  before(:each) do
    @datastream = PachubeDataFormats::Datastream.new(datastream_as_(:json))
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
  end

end
