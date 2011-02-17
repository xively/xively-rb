require File.dirname(__FILE__) + '/../spec_helper'

describe PachubeDataFormats::Feed do
  ALLOWED_KEYS = %w(created_at csv_version datastreams description email feed icon id location owner private retrieved_at status tags title updated_at website)

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

  context "input from json" do
    describe "#initialize" do
      it "should accept one parameter" do
        lambda{PachubeDataFormats::Feed.new(feed_as_(:json))}.should_not raise_exception
      end

      it "should parse and store stuff" do
        feed = PachubeDataFormats::Feed.new(feed_as_(:json))
        hash = JSON.parse(feed_as_(:json))

        feed.title.should == hash["title"]
        feed.status.should == hash["status"]
        feed.retrieved_at.should == hash["updated"]
        feed.description.should == hash["description"]
        feed.website.should == hash["website"]
        feed.private.should == hash["private"]
        feed.id.should == hash["id"]
        feed.location.should == hash["location"]
        feed.feed.should == hash["feed"]
        feed.datastreams.should == hash["datastreams"]
      end
    end
  end

  context "input from hash" do
    describe "#initialize" do
      it "should accept one parameter" do
        lambda{PachubeDataFormats::Feed.new(feed_as_(:hash))}.should_not raise_exception
      end

      it "should parse and store stuff" do
        hash = feed_as_(:hash)
        feed = PachubeDataFormats::Feed.new(hash)

        feed.title.should == hash["title"]
        feed.status.should == hash["status"]
        feed.retrieved_at.should == hash["retrieved_at"]
        feed.description.should == hash["description"]
        feed.website.should == hash["website"]
        feed.private.should == hash["private"]
        feed.id.should == hash["id"]
        feed.location.should == hash["location"]
        feed.feed.should == hash["feed"]
        feed.datastreams.should == hash["datastreams"]
      end
    end
  end

  describe "#to_json" do
    it "should output Pachube json" do
      feed = PachubeDataFormats::Feed.new(feed_as_('json'))
      output = feed.to_json
      output.should_not be_nil
      parsed = JSON.parse(output)
      parsed.should == JSON.parse(feed_as_('json'))
    end
  end

  describe "#to_hash" do
    it "should output Pachube hash" do
      feed = PachubeDataFormats::Feed.new(feed_as_('hash'))
      output = feed.to_hash
      output.should_not be_nil
      output.should == feed_as_(:hash)
    end
  end
end
