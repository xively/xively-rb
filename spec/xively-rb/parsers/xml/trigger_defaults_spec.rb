require 'spec_helper'

describe "default trigger xml parser" do
  it "should convert into attributes hash" do
    @xml = trigger_as_(:xml)
    Xively::Trigger.new(@xml).should fully_represent_trigger(:xml, @xml)
  end

  Xively::Trigger::ALLOWED_KEYS.each do |key|
    it "should handle blank '#{key}'" do
      @xml = trigger_as_(:xml, :except_node => :at)
      Xively::Trigger.new(@xml).should fully_represent_trigger(:xml, @xml)
    end
  end

  it "should raise known exception if passed garbage as xml" do
    expect {
      Xively::Trigger.new("This is not XML", :xml)
    }.to raise_error(Xively::Parsers::XML::InvalidXMLError)
  end
end

