require 'spec_helper'

describe "default datastream xml parser" do
  context "0.5.1 (used by API v2)" do
    it "should convert into attributes hash" do
      @xml = datastream_as_(:xml)
      Cosm::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should convert into attributes hash when no version string but correct xmlns" do
      xml = datastream_as_(:xml, :omit_version => true)
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, datastream_as_(:xml))
    end

    it "should handle blank tags" do
      @xml = datastream_as_(:xml, :except_node => :tag)
      Cosm::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle blank units" do
      @xml = datastream_as_(:xml, :except_node => :unit)
      Cosm::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle missing unit attributes" do
      @xml = datastream_as_(:xml, :except_node => :unit_attributes)
      Cosm::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle missing timestamps" do
      @xml = datastream_as_(:xml, :except_node => :timestamps)
      Cosm::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end
  end

  context "5 (used by API v1)" do
    it "should convert into attributes hash" do
      @xml = datastream_as_(:xml, :version => "5")
      Cosm::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should convert into attributes hash even when no version attribute if correct xmlns" do
      xml = datastream_as_(:xml, :version => "5", :omit_version => true)
      Cosm::Datastream.new(xml).should fully_represent_datastream(:xml, datastream_as_(:xml, :version => "5"))
    end

    it "should handle blank tags" do
      @xml = datastream_as_(:xml, :version => "5", :except_node => :tag)
      Cosm::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle blank units" do
      @xml = datastream_as_(:xml, :version => "5", :except_node => :unit)
      Cosm::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle missing unit attributes" do
      @xml = datastream_as_(:xml, :version => "5", :except_node => :unit_attributes)
      Cosm::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle missing value attributes" do
      @xml = datastream_as_(:xml, :version => "5", :except_node => :value_attributes)
      Cosm::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end

    it "should handle missing timestamps" do
      @xml = datastream_as_(:xml, :version => "5", :except_node => :timestamps)
      Cosm::Datastream.new(@xml).should fully_represent_datastream(:xml, @xml)
    end
  end

  it "should raise exception if passed garbage as XML" do
    expect {
      Cosm::Datastream.new("This is not xml", :xml)
    }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
  end
end

