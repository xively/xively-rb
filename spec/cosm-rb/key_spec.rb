require 'spec_helper'

describe Cosm::Key do
  it "should have a constant that defines the allowed keys" do
    Cosm::Key::ALLOWED_KEYS.sort.should == %w(expires_at id key label user permissions private_access).sort
  end

  describe "validation" do
    before(:each) do
      @key = Cosm::Key.new
    end

    %w(label permissions user).each do |field|
      it "should require a '#{field}'" do
        @key.send("#{field}=".to_sym, nil)
        @key.should_not be_valid
        @key.errors[field.to_sym].should include("can't be blank")
      end
    end

    it "should not be valid if resource present with no feed_id" do
      @key.attributes = { :user => "bob", :permissions => [ { :access_methods => ["get"], :resources => [{}] } ] }
      @key.should_not be_valid
    end

    it "should not be valid if we have a datastream_id with no feed_id in a resource" do
      @key.attributes = { :user => "bob", :permissions => [ { :access_methods => ["get"], :resources => [{:datastream_id => "0"}] } ] }
      @key.should_not be_valid
    end

    it "should always return a boolean from the permission private_access? attribute, even if nil" do
      @key.private_access.should be_nil
      @key.private_access?.should be_false
      @key.private_access = true
      @key.private_access?.should be_true
    end

    it "should not be valid if a permission object with no methods is added" do
      @key.attributes = { :user => "bob", :permissions => [ { :label => "label" } ] }
      @key.should_not be_valid
      @key.errors[:permissions_access_methods].should include("can't be blank")
    end

    it "should return the key as the id if no id attribute is specified" do
      hash = key_as_(:hash)
      hash.delete("id")
      @key.attributes = hash
      @key.id.should == "abcdefghasdfaoisdj109usasdf0a9sf"
    end
  end

  describe "#initialize" do
    it "should create a blank slate when passed no arguments" do
      key = Cosm::Key.new
      Cosm::Key::ALLOWED_KEYS.each do |attr|
        key.attributes[attr.to_sym].should be_nil
      end
    end

    it "should accept xml" do
      key = Cosm::Key.new(key_as_(:xml))
      key.permissions.first.access_methods.should == ["get", "put", "post", "delete"]
    end

    it "should accept json" do
      key = Cosm::Key.new(key_as_(:json))
      key.permissions.first.access_methods.should == ["get", "put", "post", "delete"]
    end

    it "should accept a hash of attributes" do
      key = Cosm::Key.new(key_as_(:hash))
      key.permissions.first.access_methods.should == ["get", "put", "post", "delete"]
    end

    context "specifying format" do
      it "should raise known exception if told xml but given json" do
        expect {
          Cosm::Key.new(key_as_(:json), :xml)
        }.to raise_error(Cosm::Parsers::XML::InvalidXMLError)
      end

      it "should raise known exception if told json but given xml" do
        expect {
          Cosm::Key.new(key_as_(:xml), :json)
        }.to raise_error(Cosm::Parsers::JSON::InvalidJSONError)
      end

      it "should raise known exception if given unknown format" do
        expect {
          Cosm::Key.new(key_as_(:xml), :gif)
        }.to raise_error(Cosm::InvalidFormatError)
      end
    end
  end

  describe "#attributes" do
    it "should return a hash of key properties" do
      attrs = {}
      Cosm::Key::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["permissions"] = [Cosm::Permission.new(:permissions => [:get])]
      key = Cosm::Key.new(attrs)

      key.attributes.should == attrs
    end

    it "should not return nil values" do
      attrs = {}
      Cosm::Key::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["notified_at"] = nil
      key = Cosm::Key.new(attrs)

      key.attributes.should_not include("notified_at")
    end
  end

  describe "#attributes=" do
    it "should accept and save a hash of properties" do
      key = Cosm::Key.new({})

      attrs = {}
      Cosm::Key::ALLOWED_KEYS.each do |attr|
        value = "key #{rand(1000)}"
        attrs[attr] = value
        key.should_receive("#{attr}=").with(value)
      end
      key.attributes=(attrs)
    end

    it "should accept deep nested attributes for permissions array" do
      key = Cosm::Key.new({})
      key.attributes = { :permissions_attributes => [{:label => "label", :access_methods => [:get, :put], :resources_attributes => [{:feed_id => 123, :datastream_id => "0"}]}] }
      key.permissions.size.should == 1
      key.permissions.first.label.should == "label"
      key.permissions.first.resources.size.should == 1
      key.permissions.first.resources.first.feed_id.should == 123
    end

    it "should set deep nested attributes using class instances as well (not just hashes of attributes)" do
      resource = Cosm::Resource.new(:feed_id => 123)
      permission = Cosm::Permission.new(:label => "label", :access_methods => [:get], :resources => [resource])
      key = Cosm::Key.new(:permissions => [permission])
      key.permissions.size.should == 1
      key.permissions.first.resources.size.should == 1
    end
  end

  describe "#as_json" do
    it "should call the json generator" do
      options = {:include_blanks => true}
      key = Cosm::Key.new
      key.should_receive(:generate_json).with(options).and_return({"permissions" => [:get, :put]})
      key.as_json(options).should == {"permissions" => [:get, :put]}
    end

    it "should accept *very* nil options" do
      key = Cosm::Key.new
      key.should_receive(:generate_json).with({}).and_return({"permissions" => [:get, :put]})
      key.as_json(nil).should == {"permissions" => [:get, :put]}
    end

    it "should return iso8601 formatted expires_at string if present" do
      time = Time.now
      key = Cosm::Key.new(:expires_at => time)
      key.as_json[:key][:expires_at].should == time.iso8601(6)
    end
  end

  describe "#to_json" do
    before(:each) do
      @time = Time.now
      @key_hash = { "label" => "label", :expires_at => @time, "permissions" => [{"permissions" => [:get, :put, :post], :resources => [{:feed_id => 504, :datastream_id => "0"}]}] }
    end

    it "should call #as_json" do
      key = Cosm::Key.new(@key_hash)
      key.should_receive(:as_json).with(nil)
      key.to_json
    end

    it "should pass options through to #as_json" do
      key = Cosm::Key.new(@key_hash)
      key.should_receive(:as_json).with({:crazy => "options"})
      key.to_json({:crazy => "options"})
    end

    it "should pass the output of #as_json to yajl" do
      key = Cosm::Key.new(@key_hash)
      key.should_receive(:as_json).and_return({:awesome => "hash"})
      ::JSON.should_receive(:generate).with({:awesome => "hash"})
      key.to_json
    end
  end

end
