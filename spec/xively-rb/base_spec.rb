require 'spec_helper'

describe Xively::Base do
  describe "#is_xively" do
    it "should take a class name and a hash of options" do
      lambda { Feed.is_xively }.should raise_error(ArgumentError, "wrong number of arguments (0 for 1)")
      lambda { Feed.is_xively(:feed, {}, "bogus third arg") }.should raise_error(ArgumentError, "wrong number of arguments (3 for 2)")
    end

    it "should assign mapping class" do
      class TestClass
        extend Xively::Base
        is_xively :datastream
      end
      TestClass.xively_class.should == Xively::Datastream
    end

    it "should assign mapping class for datapoints" do
      class TestClass
        extend Xively::Base
        is_xively :datapoint
      end
      TestClass.xively_class.should == Xively::Datapoint
    end

    it "should not assign mapping class if unrecognized" do
      class TestClass
        extend Xively::Base
        is_xively :hero_stream
      end
      TestClass.xively_class.should be_nil
    end

    it "should assign optional mappings" do
      class TestClass
        extend Xively::Base
        is_xively :feed, {:title => :custom_method, :website => :custom_method}
        def custom_method
          "Custom title"
        end
      end
      TestClass.xively_mappings.should == {:title => :custom_method, :website => :custom_method}
    end

    it "should include our instance methods into a class when we call it" do
      class TestClass
        extend Xively::Base
      end
      TestClass.should_receive(:include).with(Xively::Base::InstanceMethods)
      class TestClass
        is_xively :feed
      end
    end
  end
end

