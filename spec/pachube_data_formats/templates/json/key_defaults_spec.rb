require File.dirname(__FILE__) + '/../../../spec_helper'

describe "default feed json templates" do
  before(:each) do
    @key = PachubeDataFormats::Key.new(key_as_(:hash))
  end

  it "should represent Pachube JSON (used by API v2)" do
    json = @key.generate_json
    json[:key][:id].should == @key.id
    json[:key][:expires_at].should == @key.expires_at
    json[:key][:feed_id].should == @key.feed_id
    json[:key][:api_key].should == @key.key
    json[:key][:permissions].should == @key.permissions
    json[:key][:private_access].should == @key.private_access
    json[:key][:referer].should == @key.referer
    json[:key][:source_ip].should == @key.source_ip
    json[:key][:datastream_id].should == @key.datastream_id
    json[:key][:user].should == @key.user
    json[:key][:label].should == @key.label
  end
end
