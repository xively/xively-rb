require File.dirname(__FILE__) + '/../spec_helper'

describe PachubeDataFormats::Feed do
  INPUT_FORMATS = %w(json)
  OUTPUT_FORMATS = %w(json)

  INPUT_FORMATS.each do |input_format|
    context "from #{input_format}" do
      describe "#initialize" do
        it "should accept one parameter" do
          lambda{PachubeDataFormats::Feed.new(feed_as_(input_format))}.should_not raise_exception
        end

        it "should ignore unknown fields"
        #   feed = PachubeDataFormats::Feed.new({:title => "my name is", :bunny => "is a terrorist"})
        #   feed.hash[:bunny].should be_nil
        # end
      end

      OUTPUT_FORMATS.each do |output_format|
        describe "#to_#{output_format}" do
          it "should output Pachube #{output_format}" do
            feed = PachubeDataFormats::Feed.new(feed_as_(input_format))
            json = feed.send("to_#{output_format}")
            json.should_not be_nil
            parsed_json = JSON.parse(json)
            parsed_json.should == JSON.parse(feed_as_(input_format))
          end
        end
      end
    end
  end
end
