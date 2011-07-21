require File.dirname(__FILE__) + '/../../../spec_helper'

describe "default key json parser" do
  it "should convert into attributes hash" do
    @json = key_as_(:json)
    PachubeDataFormats::Key.new(@json).should fully_represent_key(:json, @json)
  end
end
