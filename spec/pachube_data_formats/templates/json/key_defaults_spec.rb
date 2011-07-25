require File.dirname(__FILE__) + '/../../../spec_helper'

describe "default feed json templates" do
  before(:each) do
    @key = PachubeDataFormats::Key.new(key_as_(:hash))
  end

  it "should represent Pachube JSON (used by API v2)" do
    json = @key.generate_json
    json[:id].should == @key.id
    json[:expires_at].should == @key.expires_at
    json[:feed_id].should == @key.feed_id
    json[:api_key].should == @key.key
    json[:permissions].should == @key.permissions
    json[:private_access].should == @key.private_access
    json[:referer].should == @key.referer
    json[:source_ip].should == @key.source_ip
    json[:datastream_id].should == @key.datastream_id
    json[:user].should == @key.user
    json[:label].should == @key.label
  end
end
