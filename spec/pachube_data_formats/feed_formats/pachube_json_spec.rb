require File.dirname(__FILE__) + '/../../spec_helper'

describe PachubeDataFormats::FeedFormats::PachubeJSON do
  it "should inherit from PachubeDataFormats::FeedFormats::Base" do
    PachubeDataFormats::FeedFormats::PachubeJSON.new.should be_a_kind_of(PachubeDataFormats::FeedFormats::Base)
  end

  describe "parser" do
    it "should parse json and return a feed hash" do
      json = feed_as_(:json)
      parsed_json = PachubeDataFormats::FeedFormats::PachubeJSON.parse(json)
      hash = JSON.parse(json)
      parsed_json["title"].should == hash["title"]
      parsed_json["status"].should == hash["status"]
      parsed_json["retrieved_at"].should == hash["updated"]
      parsed_json["description"].should == hash["description"]
      parsed_json["website"].should == hash["website"]
      parsed_json["private"].should == hash["private"]
      parsed_json["id"].should == hash["id"]
      parsed_json["location"].should == hash["location"]
      parsed_json["feed"].should == hash["feed"]
      parsed_json["datastreams"].should == hash["datastreams"]
    end
  end

  describe "generator" do
    it "should generate Pachube json" do
      attrs = {}
      PachubeDataFormats::Feed::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["datastreams"] = [{"stream_id" => "ein"}]
      json = PachubeDataFormats::FeedFormats::PachubeJSON.generate(attrs.clone)
      parsed_json = json
      parsed_json["version"].should == "1.0.0"
      parsed_json["updated"].should == attrs["retrieved_at"]
      parsed_json["title"].should == attrs["title"]
      parsed_json["status"].should == attrs["status"]
      parsed_json["description"].should == attrs["description"]
      parsed_json["website"].should == attrs["website"]
      parsed_json["private"].should == attrs["private"]
      parsed_json["id"].should == attrs["id"]
      parsed_json["location"].should == attrs["location"]
      parsed_json["feed"].should == attrs["feed"]
      parsed_json["datastreams"].should == attrs["datastreams"]
    end
  end

end

