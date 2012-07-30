require 'spec_helper'

describe "default feed csv parser" do
  describe "csv" do
    it "should convert Pachube CSV v2 into attributes hash" do
      csv = feed_as_(:csv, :version => 'v2')
      feed = Cosm::Feed.new(csv)
      feed.should fully_represent_feed(:csv_v2, csv)
    end

    it "should convert no timestamp v2 CSV into attributes hash" do
      csv = feed_as_(:csv, :version => 'v2_notimestamp')
      feed = Cosm::Feed.new(csv)
      feed.should fully_represent_feed(:csv_v2, csv)
    end

    it "should convert Pachube CSV v1 into attributes hash" do
      csv = feed_as_(:csv, :version => 'v1')
      feed = Cosm::Feed.new(csv)
      feed.should fully_represent_feed(:csv_v1, csv)
    end

    it "should raise an exception if Pachube CSV cannot be detected" do
      csv = feed_as_(:csv, :version => 'unknown')
      lambda {Cosm::Feed.new(csv)}.should raise_exception(Cosm::Parsers::CSV::UnknownVersionError)
    end

    it "should accept manually determining csv version to be v2" do
      csv = feed_as_(:csv, :version => 'unknown')
      feed = Cosm::Feed.new(csv, :v2)
      feed.should fully_represent_feed(:csv_v2, csv)
    end

    it "should accept manually determining csv version to be v1" do
      csv = feed_as_(:csv, :version => 'unknown')
      feed = Cosm::Feed.new(csv, :v1)
      feed.should fully_represent_feed(:csv_v1, csv)
    end

    it "should raise an error if passed some wild csv with more than max permitted three columns" do
      csv =<<-CSV
Date-Time, System HOA,Jockey Pump HOA,VFD Pump HOA,Lag Pump HOA,Lag Pump 2 HOA,Power Monitor,Water Level Relay,High Discharge Pressure,Reset Function,Jockey Running,VFD Run,Lag Pump Run,VFD Fault,Filter In Auto,Filter In Hand,Differential Press 1,Filter 1 Running,High Limit Switch,Low Limit Switch,Lag Pump Running,VFD Run Output Auto,VFD Pump On,Lag Pump,Lag Pump 1 On,System Auto Mode,Fault,Lag Pump 2 Run,Jockey On,Jockey Pump Run,Lag Pump 2,Filter Forward,Filter Reverse,Filter Solenoid,Pressure,Flow,Unknown?,VFD Input,VFD Output,
2009;Apr;19;12;44;15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, -1, 
2009;Apr;19;12;44;30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, -1, 
2009;Apr;19;12;48;52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, -1, 
CSV
      expect {
        Cosm::Feed.new(csv)
      }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
    end

    it "should raise an error if passed more than one row when we state it's v1" do
      csv =<<-CSV
This,2
Wrong,3
CSV

      expect {
        Cosm::Feed.new(csv, :v1)
      }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
    end
  end
end

