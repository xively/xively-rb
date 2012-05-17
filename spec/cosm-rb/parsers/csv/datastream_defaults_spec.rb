require 'spec_helper'

describe "default datastream csv parser" do
  describe "csv" do
    it "should convert Pachube CSV into attributes hash" do
      csv = datastream_as_(:csv)
      datastream = Cosm::Datastream.new(csv)
      datastream.should fully_represent_datastream(:csv, csv)
    end
  end
end

