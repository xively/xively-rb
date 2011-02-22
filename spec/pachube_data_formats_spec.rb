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
    it "should not raise an error"
  end
end
