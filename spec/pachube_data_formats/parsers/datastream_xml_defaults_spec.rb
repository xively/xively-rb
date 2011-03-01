require File.dirname(__FILE__) + '/../../spec_helper'

describe "default datastream xml parser" do
  before(:each) do
    @datastream = PachubeDataFormats::Datastream.new(datastream_as_(:json))
  end

  context "0.5.1 (used by API v2)" do
    it "should convert into attributes hash" do
      @xml = datastream_as_(:xml)
      PachubeDataFormats::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle blank tags" do
      @xml = datastream_as_(:xml, :except_node => :tag)
      PachubeDataFormats::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle blank units" do
      @xml = datastream_as_(:xml, :except_node => :unit)
      PachubeDataFormats::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle missing unit attributes" do
      @xml = datastream_as_(:xml, :except_node => :unit_attributes)
      PachubeDataFormats::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle missing timestamps" do
      @xml = datastream_as_(:xml, :except_node => :timestamps)
      PachubeDataFormats::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end
  end

  context "5 (used by API v1)" do
    it "should convert into attributes hash" do
      @xml = datastream_as_(:xml, :version => "5")
      PachubeDataFormats::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle blank tags" do
      @xml = datastream_as_(:xml, :version => "5", :except_node => :tag)
      PachubeDataFormats::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle blank units" do
      @xml = datastream_as_(:xml, :version => "5", :except_node => :unit)
      PachubeDataFormats::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle missing unit attributes" do
      @xml = datastream_as_(:xml, :version => "5", :except_node => :unit_attributes)
      PachubeDataFormats::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle missing value attributes" do
      @xml = datastream_as_(:xml, :version => "5", :except_node => :value_attributes)
      PachubeDataFormats::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle missing timestamps" do
      @xml = datastream_as_(:xml, :version => "5", :except_node => :timestamps)
      PachubeDataFormats::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end
  end
#  context "5 (used by API v1)" do
#
#    it "should convert into attributes hash" do
#      @json = datastream_as_(:json, :version => "0.6-alpha")
#      attributes = @datastream.from_json(@json)
#      json = JSON.parse(@json)
#      attributes["id"].should == json["id"]
#      attributes["updated"].should == json["values"].first["recorded_at"]
#      attributes["current_value"].should == json["values"].first["value"]
#      attributes["max_value"].should == json["values"].first["max_value"]
#      attributes["min_value"].should == json["values"].first["min_value"]
#      attributes["tags"].should == json["tags"].join(',')
#      attributes["unit_type"].should == json["unit"]["type"]
#      attributes["unit_label"].should == json["unit"]["label"]
#      attributes["unit_symbol"].should == json["unit"]["symbol"]
#    end
#
#    it "should handle blank tags" do
#      @json = datastream_as_(:json, :version => "0.6-alpha", :except => [:tags])
#      lambda {@datastream.from_json(@json)}.should_not raise_error
#    end
#  end
end

