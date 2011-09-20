require 'spec_helper'

describe "default feed json templates" do
  before(:each) do
    @key = PachubeDataFormats::Key.new(key_as_(:hash))
  end

  it "should represent Pachube JSON (used by API v2)" do
    json = @key.generate_json
    json[:key][:id].should == @key.id
    json[:key][:expires_at].should == @key.expires_at
    json[:key][:api_key].should == @key.key
    json[:key][:user].should == @key.user
    json[:key][:label].should == @key.label
    json[:key][:scopes].each_index do |scope_index|
      json[:key][:scopes][scope_index][:permissions].should == @key.scopes[scope_index].permissions
      json[:key][:scopes][scope_index][:label].should == @key.scopes[scope_index].label
      json[:key][:scopes][scope_index][:private_access].should == @key.scopes[scope_index].private_access
      json[:key][:scopes][scope_index][:referer].should == @key.scopes[scope_index].referer
      json[:key][:scopes][scope_index][:source_ip].should == @key.scopes[scope_index].source_ip
      json[:key][:scopes][scope_index][:minimum_interval].should == @key.scopes[scope_index].minimum_interval
      json[:key][:scopes][scope_index][:resources].each_index do |res_index|
        json[:key][:scopes][scope_index][:resources][res_index][:feed_id].should == @key.scopes[scope_index].resources[res_index].feed_id
        json[:key][:scopes][scope_index][:resources][res_index][:datastream_id].should == @key.scopes[scope_index].resources[res_index].datastream_id
        json[:key][:scopes][scope_index][:resources][res_index][:datastream_trigger_id].should == @key.scopes[scope_index].resources[res_index].datastream_trigger_id
      end
    end
  end
end
