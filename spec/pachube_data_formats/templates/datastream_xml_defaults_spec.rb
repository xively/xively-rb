require File.dirname(__FILE__) + '/../../spec_helper'

describe "default datastream xml templates" do
  before(:each) do
    @datastream = PachubeDataFormats::Datastream.new(datastream_as_(:hash))
  end

  context "0.5.1 (used by API V2)" do
    it "should be the default" do
      @datastream.generate_xml("0.5.1").should == @datastream.to_xml
    end

    it "should represent Pachube EEML" do
      xml = Nokogiri.parse(@datastream.generate_xml("0.5.1"))
      xml.should describe_eeml_for_version("0.5.1")
      xml.should contain_eeml_for_version("0.5.1")
    end

    it "should handle a lack of tags" do
      @datastream.tags = nil
      lambda {@datastream.generate_xml("0.5.1")}.should_not raise_error
    end
  end

  context "5 (used by API V1)" do

    it "should represent Pachube EEML" do
      xml = Nokogiri.parse(@datastream.generate_xml("5"))
      xml.should describe_eeml_for_version("5")
      xml.should contain_eeml_for_version("5")
    end

  end

  #it "should represent Pachube JSON 0.6-alpha (used by API v1)" do
  #  json = @datastream.generate_json("0.6-alpha")
  #  json[:id].should == @datastream.id
  #  json[:version].should == "0.6-alpha"
  #  json[:values].first[:recorded_at].should == @datastream.updated.iso8601
  #  json[:values].first[:value].should == @datastream.current_value
  #  json[:values].first[:max_value].should == @datastream.max_value
  #  json[:values].first[:min_value].should == @datastream.min_value
  #  json[:tags].should == @datastream.tags.split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase}
  #  json[:unit].should == {
  #    :type => @datastream.unit_type,
  #    :symbol => @datastream.unit_symbol,
  #    :label => @datastream.unit_label
  #  }
  #end

  #it "should ignore tags if nil (1.0.0)" do
  #  @datastream.tags = nil
  #  json = @datastream.generate_json("1.0.0")
  #  json[:tags].should be_nil
  #end

  #it "should ignore tags if nil (0.6-alpha)" do
  #  @datastream.tags = nil
  #  json = @datastream.generate_json("0.6-alpha")
  #  json[:tags].should be_nil
  #end

  #it "should ignore unit if none of the elements are set (1.0.0)" do
  #  @datastream.unit_label = nil
  #  @datastream.unit_symbol = nil
  #  @datastream.unit_type = nil
  #  json = @datastream.generate_json("1.0.0")
  #  json[:unit].should be_nil
  #end

  #it "should ignore unit if none of the elements are set (0.6-alpha)" do
  #  @datastream.unit_label = nil
  #  @datastream.unit_symbol = nil
  #  @datastream.unit_type = nil
  #  json = @datastream.generate_json("0.6-alpha")
  #  json[:unit].should be_nil
  #end
end

