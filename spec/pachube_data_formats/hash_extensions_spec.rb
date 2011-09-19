require 'spec_helper'

describe "Hash extensions" do
  it "should add a delete_if_nil_value method to hashes" do
    hash = { "foo" => "awesome", "bar" => nil, :symbol => "" }
    hash.delete_if_nil_value.should == { "foo" => "awesome" }
  end

  # HACK probably
  it "should add a deep_stringify_keys method to hash instances" do
    hash = { :sym => "val", :nested => { "str" => 12, :symtoo => 58 } }
    hash.deep_stringify_keys.should == { "sym" => "val", "nested" => { "str" => 12, "symtoo" => 58 } }
  end

  it "should have a destructive in place version of the deep_stringify_keys method" do
    hash = { :sym => "val", :nested => { "str" => 12, :symtoo => 58 } }
    hash.deep_stringify_keys!
    hash.should == { "sym" => "val", "nested" => { "str" => 12, "symtoo" => 58 } }
  end
end
