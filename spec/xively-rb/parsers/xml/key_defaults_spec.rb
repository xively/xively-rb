require 'spec_helper'

describe "default key xml parser" do
  it "should convert into attributes hash" do
    @xml = key_as_(:xml)
    Xively::Key.new(@xml).should fully_represent_key(:xml, @xml)
  end

  Xively::Key::ALLOWED_KEYS.each do |key|
    it "should handle blank '#{key}'" do
      @xml = key_as_(:xml, :except_node => :referer)
      Xively::Key.new(@xml).should fully_represent_key(:xml, @xml)
    end
  end

  it "should raise known exception if passed garbage as xml" do
    expect {
      Xively::Key.new("This is not XML", :xml)
    }.to raise_error(Xively::Parsers::XML::InvalidXMLError)
  end
end

