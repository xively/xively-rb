require 'spec_helper'

describe "default trigger xml parser" do
  it "should convert into attributes hash" do
    @xml = trigger_as_(:xml)
    Cosm::Trigger.new(@xml).should fully_represent_trigger(:xml, @xml)
  end

  Cosm::Trigger::ALLOWED_KEYS.each do |key|
    it "should handle blank '#{key}'" do
      @xml = trigger_as_(:xml, :except_node => :at)
      Cosm::Trigger.new(@xml).should fully_represent_trigger(:xml, @xml)
    end
  end

  it "should raise known exception if passed garbage as xml" do
    expect {
      Cosm::Trigger.new("This is not XML", :xml)
    }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
  end
end

