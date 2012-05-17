require 'spec_helper'

describe Cosm::Base do
  describe "#is_cosm" do
    it "should take a class name and a hash of options" do
      lambda { Feed.is_cosm }.should raise_error(ArgumentError, "wrong number of arguments (0 for 1)")
      lambda { Feed.is_cosm(:feed, {}, "bogus third arg") }.should raise_error(ArgumentError, "wrong number of arguments (3 for 2)")
    end

    it "should assign mapping class" do
      class TestClass
        extend Cosm::Base
        is_cosm :datastream
      end
      TestClass.cosm_class.should == Cosm::Datastream
    end

    it "should assign mapping class for datapoints" do
      class TestClass
        extend Cosm::Base
        is_cosm :datapoint
      end
      TestClass.cosm_class.should == Cosm::Datapoint
    end

    it "should not assign mapping class if unrecognized" do
      class TestClass
        extend Cosm::Base
        is_cosm :hero_stream
      end
      TestClass.cosm_class.should be_nil
    end

    it "should assign optional mappings" do
      class TestClass
        extend Cosm::Base
        is_cosm :feed, {:title => :custom_method, :website => :custom_method}
        def custom_method
          "Custom title"
        end
      end
      TestClass.cosm_mappings.should == {:title => :custom_method, :website => :custom_method}
    end

    it "should include our instance methods into a class when we call it" do
      class TestClass
        extend Cosm::Base
      end
      TestClass.should_receive(:include).with(Cosm::Base::InstanceMethods)
      class TestClass
        is_cosm :feed
      end
    end
  end
end

