require File.dirname(__FILE__) + '/../spec_helper'

describe PachubeDataFormats::ActiveRecord do
  load_schema

  describe "#is_pachube_data_format" do
    it "should take a class name and a hash of options" do
      lambda { ActiveRecord::Base.is_pachube_data_format }.should raise_error(ArgumentError, "wrong number of arguments (0 for 1)")
      lambda { ActiveRecord::Base.is_pachube_data_format(:feed, {}, "bogus third arg") }.should raise_error(ArgumentError, "wrong number of arguments (3 for 2)")
    end

    it "should assign optional mappings" do
      class TestClass < ActiveRecord::Base
        is_pachube_data_format :feed, {:title => :custom_method, :website => :custom_method}
        def custom_method
          "Custom title"
        end
      end
      TestClass.pachube_data_format_mappings.should == {:title => :custom_method, :website => :custom_method}
    end

    it "should include our instance methods into a class when we call it" do
      class TestClass < ActiveRecord::Base
      end
      TestClass.should_receive(:include).with(PachubeDataFormats::ActiveRecord::InstanceMethods)
      class TestClass < ActiveRecord::Base
        is_pachube_data_format :feed
      end
    end
  end
end

