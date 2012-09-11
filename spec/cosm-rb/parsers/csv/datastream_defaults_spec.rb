require 'spec_helper'

describe "default datastream csv parser" do
  describe "csv" do
    it "should convert Pachube CSV into attributes hash" do
      csv = datastream_as_(:csv)
      datastream = Cosm::Datastream.new(csv, :v2)
      datastream.should fully_represent_datastream(:csv, csv)
    end

    it "should capture timestamp if present" do
      csv = datastream_as_(:csv, :version => "timestamped")
      datastream = Cosm::Datastream.new(csv, :v2, :csv)
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

    it "should raise error if passed more than a single value as v1" do
      csv = "192,2"
      expect {
        Cosm::Datastream.new(csv, :v1)
      }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
    end

    it "should raise exception if passed garbage csv" do
      expect {
        Cosm::Datastream.new("badly, \"quoted", :csv)
      }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
    end

    it "should not raise exception if passed data with nil value" do
      expect {
        datastream = Cosm::Datastream.new("2012-08-12T00:00:00Z,", :v2)
        datastream.current_value.should be_empty
      }.to_not raise_error
    end

    it "should parse multiline csv" do
      csv = <<-CSV
2012-02-08T00:00:00Z,123
2012-02-08T00:00:10Z,124
2012-02-08T00:00:20Z,125
2012-02-08T00:00:30Z,126
CSV
      datastream = Cosm::Datastream.new(csv, :v2)
      datastream.updated.should be_nil
      datastream.current_value.should be_nil
      datastream.datapoints.size.should == 4
      datastream.datapoints.collect { |d| [d.at, d.value].join(",") }.join("\n").should == csv.strip
    end

    it "should not parse multiline csv passed to the v1 api" do
      csv = <<-CSV
2012-02-08T00:00:00Z,123
2012-02-08T00:00:10Z,124
2012-02-08T00:00:20Z,125
2012-02-08T00:00:30Z,126
CSV
      expect {
        datastream = Cosm::Datastream.new(csv, :v1)
      }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
    end

    it "should not accept multiline csv with just single values" do
      csv = <<-CSV
123
124
125
126
CSV

      expect {
        datastream = Cosm::Datastream.new(csv, :v2)
      }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
    end

    it "should strip whitespace from multiline values" do
      csv = <<-CSV
2012-02-08T00:00:00Z , 123
2012-02-08T00:00:10Z , 124
2012-02-08T00:00:20Z , 125
2012-02-08T00:00:30Z , 126
CSV

      datastream = Cosm::Datastream.new(csv, :v2)
      datastream.updated.should be_nil
      datastream.current_value.should be_nil
      datastream.datapoints.size.should == 4
      datastream.datapoints.sort { |a, b| a.at <=> b.at }.collect { |d| [d.at, d.value] }.should == [["2012-02-08T00:00:00Z","123"],
                                                                                                     ["2012-02-08T00:00:10Z","124"],
                                                                                                     ["2012-02-08T00:00:20Z","125"],
                                                                                                     ["2012-02-08T00:00:30Z","126"]]
    end
  end
end

