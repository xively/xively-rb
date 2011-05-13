require File.dirname(__FILE__) + '/../../../spec_helper'

describe "default trigger xml parser" do
  it "should convert into attributes hash" do
    @xml = trigger_as_(:xml)
    PachubeDataFormats::Trigger.new(@xml).should fully_represent_trigger(:xml, @xml)
  end

  PachubeDataFormats::Trigger::ALLOWED_KEYS.each do |key|
    it "should handle blank '#{key}'" do
      @xml = trigger_as_(:xml, :except_node => :at)
      PachubeDataFormats::Trigger.new(@xml).should fully_represent_trigger(:xml, @xml)
    end
  end
end

