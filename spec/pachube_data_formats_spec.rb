require File.dirname(__FILE__) + '/spec_helper'

describe PachubeDataFormats do
  context "if ActiveRecord is present" do
    it "should have extended active record" do
      ActiveRecord::Base.included_modules.should include PachubeDataFormats::ActiveRecord
    end

    it "should extend ActiveRecord with ClassMethods" do
      ActiveRecord::Base.should respond_to "is_pachube_data_format"
    end
  end

  context "if ActiveRecord is not present" do
    it "should not raise an error" do
      # If we got here we are probably ok so we'll just check that the class loaded
      # This test is a bit bunk, because it doesn't actually test it without the
      # ActiveRecord gem being present, but there doesn't seem to be a good way to
      # actually do that.  So the best we can do is to check that other stuff
      # loaded alright.
      defined?(PachubeDataFormats::Feed).should == "constant"
    end
  end
end
