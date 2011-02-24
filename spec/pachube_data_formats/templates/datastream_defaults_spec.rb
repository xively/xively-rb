require File.dirname(__FILE__) + '/../../spec_helper'

describe "default datastream templates" do
  before(:each) do
    @datastream = PachubeDataFormats::Datastream.new(datastream_as_(:hash))
  end

  describe "json" do
    it "should default to 1.0.0" do
      @datastream.generate_json("1.0.0").should == @datastream.as_json
    end

    it "should represent Pachube JSON 1.0.0 (used by API v2)" do
      json = @datastream.generate_json("1.0.0")
      json["id"].should == @datastream.id
      json["version"].should == "1.0.0"
      json["at"].should == @datastream.retrieved_at
      json["current_value"].should == @datastream.value
      json["max_value"].should == @datastream.max_value
      json["min_value"].should == @datastream.min_value
      json["tags"].should == @datastream.tag_list.split(',').map(&:strip).sort
      json["unit"].should == {
        "type" => @datastream.unit_type,
        "symbol" => @datastream.unit_symbol,
        "label" => @datastream.unit_label
      }
    end

    it "should represent Pachube JSON 0.6-alpha (used by API v1)" do
      json = @datastream.generate_json("0.6-alpha")
      json["id"].should == @datastream.id
      json["version"].should == "0.6-alpha"
      json["values"].first["recorded_at"].should == @datastream.retrieved_at
      json["values"].first["value"].should == @datastream.value
      json["values"].first["max_value"].should == @datastream.max_value
      json["values"].first["min_value"].should == @datastream.min_value
      json["tags"].should == @datastream.tag_list.split(',').map(&:strip).sort
      json["unit"].should == {
        "type" => @datastream.unit_type,
        "symbol" => @datastream.unit_symbol,
        "label" => @datastream.unit_label
      }
    end
  end
end

