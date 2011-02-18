require File.dirname(__FILE__) + '/../../spec_helper'

describe PachubeDataFormats::DatastreamFormats::Base do
  describe "self.generate" do
    it "should require one argument" do
      lambda{PachubeDataFormats::DatastreamFormats::Base.generate}.should raise_error(ArgumentError, "wrong number of arguments (0 for 1)")
    end

    it "should define a stub for generate" do
      lambda{PachubeDataFormats::DatastreamFormats::Base.generate("")}.should raise_error(RuntimeError, "Implement - self.generate(hash)")
    end
  end

  describe "self.parse" do
    it "should require one argument" do
      lambda{PachubeDataFormats::DatastreamFormats::Base.parse}.should raise_error(ArgumentError, "wrong number of arguments (0 for 1)")
    end

    it "should define a stub for parse" do
      lambda{PachubeDataFormats::DatastreamFormats::Base.parse("")}.should raise_error(RuntimeError, "Implement - self.parse(input)")
    end
  end
end

