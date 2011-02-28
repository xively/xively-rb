require File.dirname(__FILE__) + '/../spec_helper'

describe PachubeDataFormats::Template do
  describe "initialisation" do
    it "should accept an object and format" do
      template = PachubeDataFormats::Template.new(@feed, :json)
      template.subject.should == @feed
      template.presentation.should == :json
    end
  end

  describe "presenting json" do
    before(:each) do
      @feed = PachubeDataFormats::Feed.new(feed_as_(:hash))
      @template = PachubeDataFormats::Template.new(@feed, :json)
    end

    it "should allow describing :title => @feed.title" do
      @template.title
      @template.output!.should == {:title => @feed.title}
    end

    it "should allow describing :name => @feed.title" do
      @template.name {title}
      @template.output!.should == {:name => @feed.title}
    end

    it "should allow describing :tags => @feed.tags.map(&:strip).sort" do
      @template.tags { tags.map(&:strip).sort }
      @template.output!.should == {:tags => @feed.tags.map(&:strip).sort}
    end

    it "should allow describing datastreams" do
      @template.title
      @template.datastreams do |f|
        f.datastreams.collect do |ds|
          {
            :id => ds.id,
            :current_value => ds.current_value
          }
        end
      end
      datastreams = @feed.datastreams.collect {|ds| {:id => ds.id, :current_value => ds.current_value}}
      @template.output!.should == {
        :title => @feed.title,
        :datastreams => datastreams
      }
    end

    it "should ignore nils" do
      @feed.title = nil
      @template.title
      @template.output!.should == {}
    end
  end
end

