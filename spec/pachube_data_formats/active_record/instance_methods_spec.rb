require File.dirname(__FILE__) + '/../../spec_helper'

describe PachubeDataFormats::ActiveRecord::InstanceMethods do
  load_schema

  describe "#to_pachube_json" do
    it "should return Pachube json based on the object's attributes" do
      feed = Feed.create!(:title => "Pachube Feed", :description => "Stuff", :website => "http://pachube.com", :tag_list => "alpha, beta, aardvark, kittens", :owner => Owner.create!(:login => "fred", :email => "fred@example.com"))
      PachubeDataFormats::Feed.should_receive(:new).with(feed.attributes).and_return(:feed => "json representation of a feed")
      feed.to_pachube_json.should == {:feed => "json representation of a feed"}.to_json
    end

  end

end
