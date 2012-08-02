require 'spec_helper'

describe "default datastream csv parser" do
  describe "csv" do
    it "should convert Pachube CSV into attributes hash" do
      csv = datastream_as_(:csv)
      datastream = Cosm::Datastream.new(csv)
      datastream.should fully_represent_datastream(:csv, csv)
    end

    it "should capture timestamp if present" do
      csv = datastream_as_(:csv, :version => "timestamped")
      datastream = Cosm::Datastream.new(csv)
      datastream.updated.should == "2011-02-16T16:21:01.834174Z"
      datastream.current_value.should == "14"
    end

    it "should raise error if passed more than a single row" do
      csv = "12\n13"
      expect {
        Cosm::Datastream.new(csv)
      }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
    end

    it "should raise error passed more than three values in a row" do
      csv = "#{Time.now.iso8601(6)},123,456"
      expect {
        Cosm::Datastream.new(csv)
      }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
    end

    it "should raise exception if passed garbage csv" do
      expect {
        Cosm::Datastream.new("badly, \"quoted", :csv)
      }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
    end
  end
end

