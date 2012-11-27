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

    it "should accept explicit blank values for v2 csv" do
      expect {
        Cosm::Feed.new("stream_id,''", :v2)
      }.to_not raise_error(Cosm::Parsers::CSV::InvalidCSVError)
    end

    it "should raise an error if passed some v2 csv that does not contain a value" do
      expect {
        Cosm::Feed.new("stream_id", :v2)
      }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
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
Is,4
CSV

      expect {
        Cosm::Feed.new(csv, :v1)
      }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError, /3 rows/)
    end

    context "nil attribute csv" do
      before(:each) do
        @csv = "0,,"
      end

      it "should not raise exception if csv has nil values as v1" do
        expect {
          feed = Cosm::Feed.new(@csv, :v1)
          feed.datastreams.size.should == 3
        }.to_not raise_error
      end

      it "should not raise exception if csv has nil attributes as v2" do
        expect {
          feed = Cosm::Feed.new(@csv, :v2)
          feed.datastreams.size.should == 1
        }.to_not raise_error
      end
    end

    context "unwanted whitespace" do
      it "should strip whitespace from v2" do
        dodgy_csv = <<-CSV
      0, 00035  
stream1, 0012
      2, 2012-08-02T14:11:14Z ," red car "
CSV
        good_csv = <<-CSV
0,00035
stream1,0012
2,2012-08-02T14:11:14Z,red car
CSV
        feed = Cosm::Feed.new(dodgy_csv)
        feed.should fully_represent_feed(:csv_v2, good_csv)
      end

      it "should strip whitespace from v1" do
        dodgy_csv = %Q{  00035  ,  0012," red car"}
        good_csv = "00035,0012,red car"
        feed = Cosm::Feed.new(dodgy_csv)
        feed.should fully_represent_feed(:csv_v1, good_csv)
      end
    end

    context "multivalue csv" do
      def check_multiline_csv(csv)
        feed = Cosm::Feed.new(csv)

        feed.datastreams.size.should == 2
        feed.datastreams.each do |datastream|
          datastream.updated.should be_nil
          datastream.current_value.should be_nil
          datastream.datapoints.size.should == 3
          datastream.datapoints.sort { |a,b| a.at <=> b.at }.collect { |d| [d.at, d.value] }.should == [["2012-08-12T00:00:00Z", "1"],
                                                                                               ["2012-08-12T00:00:05Z", "2"],
                                                                                               ["2012-08-12T00:00:10Z", "3"]]
        end
      end

      it "should capture multivalue csv with timestamps" do
        csv = <<-CSV
stream0,2012-08-12T00:00:00Z,1
stream1,2012-08-12T00:00:00Z,1
stream0,2012-08-12T00:00:05Z,2
stream1,2012-08-12T00:00:05Z,2
stream0,2012-08-12T00:00:10Z,3
stream1,2012-08-12T00:00:10Z,3
CSV

        check_multiline_csv(csv)
      end

      it "should capture multivalue csv with timestamps no matter the grouping" do
        csv = <<-CSV
stream0,2012-08-12T00:00:00Z,1
stream0,2012-08-12T00:00:05Z,2
stream0,2012-08-12T00:00:10Z,3
stream1,2012-08-12T00:00:00Z,1
stream1,2012-08-12T00:00:05Z,2
stream1,2012-08-12T00:00:10Z,3
CSV

        check_multiline_csv(csv)
      end

      it "should strip whitespace from multiline csv" do
        csv = <<-CSV
stream0, 2012-08-12T00:00:00Z, 1
stream0, 2012-08-12T00:00:05Z, 2
stream0, 2012-08-12T00:00:10Z, 3
stream1, 2012-08-12T00:00:00Z, 1
stream1, 2012-08-12T00:00:05Z, 2
stream1, 2012-08-12T00:00:10Z, 3
CSV

        check_multiline_csv(csv)
      end

      it "should reject multivalue csv without timestamps" do
        csv = <<-CSV
stream0,1
stream1,1
stream0,2
stream1,2
stream0,3
stream1,3
CSV
        expect {
          Cosm::Feed.new(csv)
        }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
      end

      it "should reject multivalue csv if we tell it its v1" do
        csv = <<-CSV
stream0,2012-08-12T00:00:00Z,1
stream1,2012-08-12T00:00:00Z,1
CSV

        expect {
          Cosm::Feed.new(csv, :v1)
        }.to raise_error(Cosm::Parsers::CSV::InvalidCSVError)
      end

      it "should permit an individual value within a larger update to not have a timestamp" do
        csv = <<-CSV
stream0,2012-08-12T00:00:00Z,1
stream1,2012-08-12T00:00:00Z,1
stream0,2012-08-12T00:00:05Z,2
stream1,2012-08-12T00:00:05Z,2
stream0,2012-08-12T00:00:10Z,3
stream1,2012-08-12T00:00:10Z,3
stream2,4
CSV
        feed = Cosm::Feed.new(csv)
        feed.datastreams.size.should == 3
        sorted_datastreams = feed.datastreams.sort { |a, b| a.id <=> b.id }
        [0,1].each do |i|
          sorted_datastreams[i].current_value.should be_nil
          sorted_datastreams[i].updated.should be_nil
          sorted_datastreams[i].datapoints.size.should == 3
        end
        sorted_datastreams[2].current_value.should == "4"
      end
    end
  end
end

