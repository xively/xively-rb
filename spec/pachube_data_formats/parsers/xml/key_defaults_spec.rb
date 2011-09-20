require 'spec_helper'

describe "default key xml parser" do
  it "should convert into attributes hash" do
    @xml = key_as_(:xml)
    PachubeDataFormats::Key.new(@xml).should fully_represent_key(:xml, @xml)
  end

  PachubeDataFormats::Key::ALLOWED_KEYS.each do |key|
    it "should handle blank '#{key}'" do
      @xml = key_as_(:xml, :except_node => :referer)
      PachubeDataFormats::Key.new(@xml).should fully_represent_key(:xml, @xml)
    end
  end
end

