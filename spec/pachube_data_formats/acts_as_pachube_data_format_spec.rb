require File.dirname(__FILE__) + '/../spec_helper'

class TestEnvironment < ActiveRecord::Base
  set_table_name :environments
  acts_as_pachube_data_format :feed
end

describe ActsAsPachubeDataFormat do
  load_schema

  context "::ClassMethods" do
    describe "#is_pachube_data_format" do
      it "should take a class name and a hash of options" do
        lambda { ActiveRecord::Base.acts_as_pachube_data_format }.should raise_error(ArgumentError, "wrong number of arguments (0 for 1)")
        lambda { ActiveRecord::Base.acts_as_pachube_data_format(:feed, {}, "bogus third arg") }.should raise_error(ArgumentError, "wrong number of arguments (3 for 2)")
      end

      it "should include our instance methods into a class when we call it" do
        class TestClass < ActiveRecord::Base
        end
        TestClass.should_receive(:include).with(ActsAsPachubeDataFormat::InstanceMethods)
        class TestClass < ActiveRecord::Base
          acts_as_pachube_data_format :feed
        end
      end
    end
  end

  context "::InstanceMethods" do
  end
end
