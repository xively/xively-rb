require File.dirname(__FILE__) + '/../spec_helper'

describe PachubeDataFormats::Feed do
  INPUT_FORMATS = %w(json)
  OUTPUT_FORMATS = %w(json)

  INPUT_FORMATS.each do |format|
    context "input from #{format}" do
      describe "#initialize" do
        it "should accept one parameter" do
          lambda{PachubeDataFormats::Feed.new(feed_as_(format))}.should_not raise_exception
        end

        it "should ignore unknown fields"
        #  feed = PachubeDataFormats::Feed.new({:title => "my name is", :bunny => "is a terrorist"})
        #  feed.hash[:bunny].should be_nil
        #end
      end
    end
  end

  OUTPUT_FORMATS.each do |format|
    context "output to #{format}" do
      describe "#to_#{format}" do
        it "should output Pachube #{format}" do
          feed = PachubeDataFormats::Feed.new(feed_as_("json"))
          json = feed.send("to_#{format}")
          json.should_not be_nil
          parsed_json = JSON.parse(json)
          parsed_json.should == JSON.parse(feed_as_("json"))
        end
      end
    end
  end
end
