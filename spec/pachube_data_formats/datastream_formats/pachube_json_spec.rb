require File.dirname(__FILE__) + '/../../spec_helper'

describe PachubeDataFormats::DatastreamFormats::PachubeJSON do
  it "should inherit from PachubeDataFormats::DatastreamFormats::Base" do
    PachubeDataFormats::DatastreamFormats::PachubeJSON.new.should be_a_kind_of(PachubeDataFormats::DatastreamFormats::Base)
  end

  describe "parser" do
    it "should parse json and return a datastream hash" do
      json = datastream_as_(:json)
      parsed_json = PachubeDataFormats::DatastreamFormats::PachubeJSON.parse(json)
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
      json = PachubeDataFormats::DatastreamFormats::PachubeJSON.generate(attrs.clone)
      parsed_json = json
      parsed_json["id"].should == attrs["id"]
      parsed_json["at"].should == attrs["retrieved_at"]
      parsed_json["current_value"].should == attrs["value"]
      parsed_json["max_value"].should == attrs["max_value"]
      parsed_json["min_value"].should == attrs["min_value"]
      parsed_json["tags"].should == attrs["tag_list"].split(',')
      parsed_json["unit"].should == {
        "type" => attrs["unit_type"],
        "symbol" => attrs["unit_symbol"],
        "label" => attrs["unit_label"]
      }
    end
  end

end

