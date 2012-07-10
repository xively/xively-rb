require 'spec_helper'

describe "default datastream csv parser" do
  describe "csv" do
    it "should convert Pachube CSV into attributes hash" do
      csv = datastream_as_(:csv)
      datastream = Cosm::Datastream.new(csv)
      datastream.should fully_represent_datastream(:csv, csv)
    end

    it "should capture timestamp if present" do
      timestamp = Time.now.iso8601(6)
      csv = "#{timestamp},123"
      datastream = Cosm::Datastream.new(csv)
      datastream.updated.should == timestamp
      datastream.current_value.should == "123"
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
  end
end

