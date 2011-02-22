require File.dirname(__FILE__) + '/../../../spec_helper'

describe PachubeDataFormats::Formats::Datastreams::JSON do
  it "should inherit from PachubeDataFormats::Formats::Datastreams::Base" do
    PachubeDataFormats::Formats::Datastreams::JSON.new.should be_a_kind_of(PachubeDataFormats::Formats::Base)
  end

  describe "parser" do
    it "should parse json and return a datastream hash" do
      json = datastream_as_(:json)
      parsed_json = PachubeDataFormats::Formats::Datastreams::JSON.parse(json)
      hash = JSON.parse(json)
      parsed_json["id"].should == hash["id"]
      parsed_json["retrieved_at"].should == hash["at"]
      parsed_json["value"].should == hash["current_value"]
      parsed_json["max_value"].should == hash["max_value"]
      parsed_json["min_value"].should == hash["min_value"]
      parsed_json["tag_list"].should == hash["tags"].join(",")
      parsed_json["unit_type"].should == hash["unit"]["type"]
      parsed_json["unit_symbol"].should == hash["unit"]["symbol"]
      parsed_json["unit_label"].should == hash["unit"]["label"]
    end
  end

  describe "generator" do
    it "should generate Pachube json" do
      attrs = {}
      PachubeDataFormats::Datastream::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["tag_list"] = "alpha, gamma, ray gun, freakin lasers"
      json = PachubeDataFormats::Formats::Datastreams::JSON.generate(attrs.clone)
      parsed_json = json
      parsed_json["id"].should == attrs["id"]
      parsed_json["at"].should == attrs["retrieved_at"]
      parsed_json["current_value"].should == attrs["value"]
      parsed_json["max_value"].should == attrs["max_value"]
      parsed_json["min_value"].should == attrs["min_value"]
      parsed_json["tags"].should == attrs["tag_list"].split(',').map(&:strip).sort
      parsed_json["unit"].should == {
        "type" => attrs["unit_type"],
        "symbol" => attrs["unit_symbol"],
        "label" => attrs["unit_label"]
      }
    end

    it "should optionally generate Pachube 0.6-alpha JSON" do
      attrs = {}
      PachubeDataFormats::Datastream::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["tag_list"] = "alpha, gamma, ray gun, freakin lasers"
      json = PachubeDataFormats::Formats::Datastreams::JSON.generate(attrs.clone.merge("version" => "0.6-alpha"))
      parsed_json = json
      parsed_json["id"].should == attrs["id"]
      parsed_json["values"]["recorded_at"].should == attrs["retrieved_at"]
      parsed_json["values"]["value"].should == attrs["value"]
      parsed_json["values"]["max_value"].should == attrs["max_value"]
      parsed_json["values"]["min_value"].should == attrs["min_value"]
      parsed_json["tags"].should == attrs["tag_list"].split(',').map(&:strip).sort
      parsed_json["unit"].should == {
        "type" => attrs["unit_type"],
        "symbol" => attrs["unit_symbol"],
        "label" => attrs["unit_label"]
      }

    end

    it "should generate minimal Pachube JSON" do
      json = PachubeDataFormats::Formats::Datastreams::JSON.generate({"id" => "one", "value" => "1"})
      json.should == {"id" => "one", "current_value"=>"1"}
    end
  end

end

