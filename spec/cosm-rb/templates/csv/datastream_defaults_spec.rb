require 'spec_helper'

describe "default datastream json templates" do
  before(:each) do
    @datastream = Cosm::Datastream.new(datastream_as_(:hash))
  end

  context "version 2 (used by API V2)" do

    it "should default to 2" do
      @datastream.generate_csv("2").should == @datastream.to_csv
    end

    it "should only show datapoints if there are any" do
      csv = @datastream.generate_csv("2")
      csv.should == @datastream.datapoints.collect {|dp| "#{dp.at.iso8601(6)},#{dp.value}"}.join("\n")
    end

    it "should represent datastream in Pachube CSV v2 if no datapoints" do
      @datastream.datapoints = []
      csv = @datastream.generate_csv("2")
      csv.should == "#{@datastream.updated.iso8601(6)},#{@datastream.current_value}"
    end

    context "depth" do
      it "should allow representation of datastream at depth 4" do
        @datastream.datapoints = []
        csv = @datastream.generate_csv("2", :depth => 4)
        csv.should == "#{@datastream.feed_id},#{@datastream.id},#{@datastream.updated.iso8601(6)},#{@datastream.current_value}"
      end

      it "should allow representation of datapoints at depth 4" do
        csv = @datastream.generate_csv("2", :depth => 4)
        csv.should == @datastream.datapoints.collect {|dp| "#{@datastream.feed_id},#{@datastream.id},#{dp.at.iso8601(6)},#{dp.value}"}.join("\n")
      end

      it "should allow representation of datastream at depth 4" do
        @datastream.datapoints = []
        csv = @datastream.generate_csv("2", :depth => 3)
        csv.should == "#{@datastream.id},#{@datastream.updated.iso8601(6)},#{@datastream.current_value}"
      end

      it "should allow representation of datapoints at depth 4" do
        csv = @datastream.generate_csv("2", :depth => 3)
        csv.should == @datastream.datapoints.collect {|dp| "#{@datastream.id},#{dp.at.iso8601(6)},#{dp.value}"}.join("\n")
      end

      it "should allow representation of datastream at depth 4" do
        @datastream.datapoints = []
        csv = @datastream.generate_csv("2", :depth => 2)
        csv.should == "#{@datastream.updated.iso8601(6)},#{@datastream.current_value}"
      end

      it "should allow representation of datapoints at depth 4" do
        csv = @datastream.generate_csv("2", :depth => 2)
        csv.should == @datastream.datapoints.collect {|dp| "#{dp.at.iso8601(6)},#{dp.value}"}.join("\n")
      end

      it "should allow representation of datastream at depth 4" do
        @datastream.datapoints = []
        csv = @datastream.generate_csv("2", :depth => 1)
        csv.should == "#{@datastream.current_value}"
      end

      it "should allow representation of datapoints at depth 4" do
        csv = @datastream.generate_csv("2", :depth => 1)
        csv.should == @datastream.datapoints.collect {|dp| "#{dp.value}"}.join("\n")
      end

    end


    it "should allow a full representation of datastream" do
      @datastream.datapoints = []
      csv = @datastream.generate_csv("2", :full => true)
      csv.should == "#{@datastream.feed_id},#{@datastream.id},#{@datastream.updated.iso8601(6)},#{@datastream.current_value}"
    end

    it "should allow a full representation of datapoints" do
      csv = @datastream.generate_csv("2", :full => true)
      csv.should == @datastream.datapoints.collect {|dp| "#{@datastream.feed_id},#{@datastream.id},#{dp.at.iso8601(6)},#{dp.value}"}.join("\n")
    end

    it "should escape characters that could upset csv parsers without datapoints" do
      @datastream.current_value = "one,field"
      @datastream.datapoints = []
      csv = @datastream.generate_csv("2")
      csv.should == Cosm::CSV.generate_line([@datastream.updated.iso8601(6),@datastream.current_value]).strip
    end

    it "should escape characters that could upset csv parsers with datapoints" do
      @datastream.current_value = "one,field"
      @datastream.datapoints.each do |dp|
        dp.value = "1,field"
      end
      csv = @datastream.generate_csv("2")
      csv.should == @datastream.datapoints.collect {|dp| Cosm::CSV.generate_line([dp.at.iso8601(6),dp.value]).strip }.join("\n")
    end

    it "should escape characters that could upset csv parsers without datapoints via full" do
      @datastream.current_value = "one,field"
      @datastream.datapoints = []
      csv = @datastream.generate_csv("2", :full => true)
      csv.should == Cosm::CSV.generate_line([@datastream.feed_id,@datastream.id,@datastream.updated.iso8601(6),@datastream.current_value]).strip
    end

    it "should escape characters that could upset csv parsers with datapoints via full" do
      @datastream.current_value = "one,field"
      @datastream.datapoints.each do |dp|
        dp.value = "1,field"
      end
      csv = @datastream.generate_csv("2", :full => true)
      csv.should == @datastream.datapoints.collect {|dp| Cosm::CSV.generate_line([@datastream.feed_id,@datastream.id,dp.at.iso8601(6),dp.value]).strip }.join("\n")
    end
  end

  context "version 1 (used by API V1)" do

    it "should represent Pachube CSV v1" do
      csv = @datastream.generate_csv("1")
      csv.should == @datastream.current_value
    end

    it "should escape characters that could upset csv parsers" do
      @datastream.current_value = "I \n am full of c,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, evil"
      csv = @datastream.generate_csv("1")
      csv.should == Cosm::CSV.generate_line([@datastream.current_value]).strip
    end
  end
end

