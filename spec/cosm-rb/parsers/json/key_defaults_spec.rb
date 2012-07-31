require 'spec_helper'

describe "default key json parser" do
  it "should convert into attributes hash" do
    @json = key_as_(:json)
    Cosm::Key.new(@json).should fully_represent_key(:json, @json)
  end

  it "should raise known exception if passed garbage as json" do
    expect {
      Cosm::Key.new("this ain't json", :json)
    }.to raise_error(Cosm::Parsers::JSON::InvalidJSONError)
  end
end
