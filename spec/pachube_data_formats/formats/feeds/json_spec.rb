require File.dirname(__FILE__) + '/../../../spec_helper'

describe PachubeDataFormats::Formats::Feeds::JSON do
  it "should inherit from PachubeDataFormats::Formats::Feeds::Base" do
    PachubeDataFormats::Formats::Feeds::JSON.new.should be_a_kind_of(PachubeDataFormats::Formats::Base)
  end

  describe "parser" do
    it "should parse json and return a feed hash" do
      json = feed_as_(:json)
      parsed_json = PachubeDataFormats::Formats::Feeds::JSON.parse(json)
      hash = JSON.parse(json)
      parsed_json["title"].should == hash["title"]
      parsed_json["status"].should == hash["status"]
      parsed_json["retrieved_at"].should == hash["updated"]
      parsed_json["description"].should == hash["description"]
      parsed_json["website"].should == hash["website"]
      parsed_json["private"].should == hash["private"]
      parsed_json["tag_list"].should == hash["tags"].join(",")
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
      attrs["tag_list"] = "a,z, deeee, nine"
      json = PachubeDataFormats::Formats::Feeds::JSON.generate(attrs.clone)
      parsed_json = json
      parsed_json["updated"].should == attrs["retrieved_at"]
      parsed_json["title"].should == attrs["title"]
      parsed_json["status"].should == attrs["status"]
      parsed_json["description"].should == attrs["description"]
      parsed_json["website"].should == attrs["website"]
      parsed_json["private"].should == attrs["private"]
      parsed_json["id"].should == attrs["id"]
      parsed_json["location"].should == attrs["location"]
      parsed_json["feed"].should == attrs["feed"]
      parsed_json["tags"].should == attrs["tag_list"].split(',').map(&:strip).sort
      parsed_json["datastreams"].should == attrs["datastreams"]
    end

    it "should optionally generate Pachube 0.6-alpha JSON" do
      attrs = {}
      PachubeDataFormats::Feed::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["datastreams"] = [{"stream_id" => "ein"}]
      attrs["tag_list"] = "a,z, deeee, nine"
      json = PachubeDataFormats::Formats::Feeds::JSON.generate(attrs.clone.merge("version" => "0.6-alpha"))
      parsed_json = json
      parsed_json["updated"].should == attrs["retrieved_at"]
      parsed_json["title"].should == attrs["title"]
      parsed_json["status"].should == attrs["status"]
      parsed_json["description"].should == attrs["description"]
      parsed_json["website"].should == attrs["website"]
      parsed_json["private"].should be_nil
      parsed_json["id"].should == attrs["id"]
      parsed_json["location"].should == attrs["location"]
      parsed_json["feed"].should == attrs["feed"]
      parsed_json["tags"].should be_nil
      parsed_json["datastreams"].should == attrs["datastreams"]
    end
  end

end

