require File.dirname(__FILE__) + '/../../../spec_helper'

describe "default datastream json templates" do
  before(:each) do
    @datastream = PachubeDataFormats::Datastream.new(datastream_as_(:hash))
  end

  context "version 2 (used by API V2)" do

    it "should default to 2" do
      @datastream.generate_csv("2").should == @datastream.to_csv
    end

    it "should represent Pachube CSV v2" do
      csv = @datastream.generate_csv("2")
      csv.should == "#{@datastream.updated.iso8601(6)},#{@datastream.current_value}"
    end

    it "should allow a full representation" do
      csv = @datastream.generate_csv("2", :full => true)
      csv.should == "#{@datastream.feed_id},#{@datastream.id},#{@datastream.updated.iso8601(6)},#{@datastream.current_value}"
    end
  end

  context "version 1 (used by API V1)" do

    it "should represent Pachube CSV v1" do
      csv = @datastream.generate_csv("1")
      csv.should == @datastream.current_value
    end

  end
end

