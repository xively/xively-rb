require 'spec_helper'

describe "Cosm::Client" do
  before do
    @client = Cosm::Client.new("abcdefg")
  end

  it "should have the base uri defined" do
    Cosm::Client.base_uri.should == 'https://api.cosm.com'
  end

  it "should be initializable with an api key" do
    @client.api_key.should eql("abcdefg")
  end

  describe "#get" do
    it "should make the appropriate request" do
      request_stub = stub_request(:get, "#{Cosm::Client.base_uri}/v2/feeds/504.json").
        with(:headers => {'User-Agent' => Cosm::Client.user_agent, 'X-ApiKey' => 'abcdefg'})
      @client.get('/v2/feeds/504.json')
      request_stub.should have_been_made
    end
  end

  describe "#put" do
    it "should make the appropriate request" do
      request_stub = stub_request(:put, "#{Cosm::Client.base_uri}/v2/feeds/504.json").
        with(:headers => {'User-Agent' => Cosm::Client.user_agent, 'X-ApiKey' => 'abcdefg'}, :body => "dataz")
      @client.put('/v2/feeds/504.json', :body => "dataz")
      request_stub.should have_been_made
    end
  end

  describe "#post" do
    it "should make the appropriate request" do
      request_stub = stub_request(:post, "#{Cosm::Client.base_uri}/v2/feeds/504.json").
        with(:headers => {'User-Agent' => Cosm::Client.user_agent, 'X-ApiKey' => 'abcdefg'}, :body => "dataz")
      @client.post('/v2/feeds/504.json', :body => "dataz")
      request_stub.should have_been_made
    end
  end

  describe "#delete" do
    it "should make the appropriate request" do
      request_stub = stub_request(:delete, "#{Cosm::Client.base_uri}/v2/feeds/504/datastreams/test.json").
        with(:headers => {'User-Agent' => Cosm::Client.user_agent, 'X-ApiKey' => 'abcdefg'})
      @client.delete('/v2/feeds/504/datastreams/test.json')
      request_stub.should have_been_made
    end
  end
end
