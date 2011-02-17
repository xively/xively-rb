require File.dirname(__FILE__) + '/../spec_helper'

describe PachubeDataFormats::Feed do
  INPUT_FORMATS = %w(json hash)
  OUTPUT_FORMATS = %w(json hash)

  #context "instance methods" do
  #  before(:each) do
  #    @feed = PachubeDataFormats::Feed.new(feed_as_(:json))
  #  end

  #  describe "#hash=" do
  #    it "should be possible to set whitelisted fields" do
  #      %w(datastreams status updated tags description title website private version id location feed).each do |key|
  #        @feed.hash[key] = key
  #        @feed.hash[key].should == key
  #      end
  #    end

  #    it "should not be possible to set non-whitelisted fields" do
  #      @feed.hash['something_bogus'] = 'whatevs'
  #      @feed.hash['something_bogus'].should be_nil
  #    end
  #  end
  #end

  INPUT_FORMATS.each do |format|
    context "input from #{format}" do
      describe "#initialize" do
        it "should accept one parameter" do
          lambda{PachubeDataFormats::Feed.new(feed_as_(format))}.should_not raise_exception
        end

        it "should ignore unknown fields" do
          feed = PachubeDataFormats::Feed.new(feed_as_(format, :with => {:unknown_field => "is like totally bogus"}))
          feed.hash["unknown_field"].should be_nil
        end

        it "should store all hash keys as strings (never as symbols)" do
          feed = PachubeDataFormats::Feed.new(feed_as_(format))
          feed.hash.each do |key, _|
            raise "Stored a key as a #{key.class} instead of a String" unless key.class == String
          end
        end
      end
    end
  end

  OUTPUT_FORMATS.each do |format|
    context "output to #{format}" do
      describe "#to_#{format}" do
        it "should output Pachube #{format}" do
          feed = PachubeDataFormats::Feed.new(feed_as_(format))
          output = feed.send("to_#{format}")
          output.should_not be_nil
          output.parse_feed_as_(format).should == feed_as_(format).parse_feed_as_(format)
        end
      end
    end
  end
end
