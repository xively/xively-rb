require File.dirname(__FILE__) + '/../spec_helper'

describe PachubeDataFormats::Feed do
  INPUT_FORMATS = %w(json)

  INPUT_FORMATS.each do |format|
  context "#initialize" do
    it "should accept '#{format}' representation of a feed" do
      lambda{PachubeDataFormats::Feed.new(feed_as_(format))}.should_not raise_exception
    end

  end



  end
end
