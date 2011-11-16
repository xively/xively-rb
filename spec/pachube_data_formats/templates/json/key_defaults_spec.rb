require 'spec_helper'

describe "default key json templates" do
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
    json[:key][:private_access].should == @key.private_access
    json[:key][:permissions].each_index do |permission_index|
      json[:key][:permissions][permission_index][:access_types].should == @key.permissions[permission_index].access_types
      json[:key][:permissions][permission_index][:label].should == @key.permissions[permission_index].label
      json[:key][:permissions][permission_index][:referer].should == @key.permissions[permission_index].referer
      json[:key][:permissions][permission_index][:source_ip].should == @key.permissions[permission_index].source_ip
      json[:key][:permissions][permission_index][:minimum_interval].should == @key.permissions[permission_index].minimum_interval
      json[:key][:permissions][permission_index][:resources].each_index do |res_index|
        json[:key][:permissions][permission_index][:resources][res_index][:feed_id].should == @key.permissions[permission_index].resources[res_index].feed_id
        json[:key][:permissions][permission_index][:resources][res_index][:datastream_id].should == @key.permissions[permission_index].resources[res_index].datastream_id
        json[:key][:permissions][permission_index][:resources][res_index][:datastream_trigger_id].should == @key.permissions[permission_index].resources[res_index].datastream_trigger_id
      end
    end
  end
end
