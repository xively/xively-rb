require File.dirname(__FILE__) + '/../spec_helper'

describe PachubeDataFormats::Feed do
  INPUT_FORMATS = %w(json hash)
  OUTPUT_FORMATS = %w(json hash)
  #ALLOWED_KEYS = %w(datastreams status updated tags description title website private version id location feed)
  ALLOWED_KEYS = %w(retrieved_at created_at title csv_version updated_at private deleted_at feed_content owner_id mime_type id icon website tag_list feed_retrieved description mapped feed_content_hash feed email)

  context "instance methods" do
    before(:each) do
      @feed = PachubeDataFormats::Feed.new(feed_as_(:json))
    end

    describe "setting whitelisted fields" do
      ALLOWED_KEYS.each do |key|
        it "##{key}=" do
          lambda {
            @feed.send("#{key}=", key)
          }.should_not raise_error
        end
      end
    end

    describe "getting whitelisted fields" do
      ALLOWED_KEYS.each do |key|
        it "##{key}" do
          lambda {
            @feed.send(key)
          }.should_not raise_error
        end
      end
    end

    describe "setting non-whitelisted keys" do
      it "should not be possible to set non-whitelisted fields" do
        lambda {
          @feed.something_bogus = 'whatevs'
        }.should raise_error
      end

      it "should not be possible to get non-whitelisted fields" do
        lambda {
          @feed.something_bogus
        }.should raise_error
      end
    end
  end

  INPUT_FORMATS.each do |format|
    context "input from #{format}" do
      describe "#initialize" do
        it "should accept one parameter" do
          lambda{PachubeDataFormats::Feed.new(feed_as_(format))}.should_not raise_exception
        end

        it "should parse and store all pertinent fields" do
          feed = PachubeDataFormats::Feed.new(feed_as_(format))
          hash = feed_as_(:hash)
          ALLOWED_KEYS.each do |key|
            feed.send(key).should == hash[key]
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
