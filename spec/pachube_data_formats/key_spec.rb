require 'spec_helper'

describe PachubeDataFormats::Key do
  it "should have a constant that defines the allowed keys" do
    PachubeDataFormats::Key::ALLOWED_KEYS.sort.should == %w(expires_at id key label user scopes).sort
  end

  describe "validation" do
    before(:each) do
      @key = PachubeDataFormats::Key.new
    end

    %w(scopes user).each do |field|
      it "should require a '#{field}'" do
        @key.send("#{field}=".to_sym, nil)
        @key.should_not be_valid
        @key.errors[field.to_sym].should include("can't be blank")
      end
    end

    it "should not be valid if resource present with no feed_id" do
      @key.attributes = { :user => "bob", :scopes => [ { :permissions => ["get"], :resources => [{}] } ] }
      @key.should_not be_valid
    end

    it "should not be valid if we have a datastream_id with no feed_id in a resource" do
      @key.attributes = { :user => "bob", :scopes => [ { :permissions => ["get"], :resources => [{:datastream_id => "0"}] } ] }
      @key.should_not be_valid
    end
  end

  describe "#initialize" do
    it "should create a blank slate when passed no arguments" do
      key = PachubeDataFormats::Key.new
      PachubeDataFormats::Key::ALLOWED_KEYS.each do |attr|
        key.attributes[attr.to_sym].should be_nil
      end
    end

    it "should accept xml" do
      key = PachubeDataFormats::Key.new(key_as_(:xml))
      key.scopes.first.permissions.should == ["get", "put", "post", "delete"]
    end

    it "should accept json" do
      key = PachubeDataFormats::Key.new(key_as_(:json))
      key.scopes.first.permissions.should == ["get", "put", "post", "delete"]
    end

    it "should accept a hash of attributes" do
      key = PachubeDataFormats::Key.new(key_as_(:hash))
      key.scopes.first.permissions.should == ["get", "put", "post", "delete"]
    end
  end

  describe "#attributes" do
    it "should return a hash of key properties" do
      attrs = {}
      PachubeDataFormats::Key::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["scopes"] = [PachubeDataFormats::Key::Scope.new(:permissions => [:get])]
      key = PachubeDataFormats::Key.new(attrs)

      key.attributes.should == attrs
    end

    it "should not return nil values" do
      attrs = {}
      PachubeDataFormats::Key::ALLOWED_KEYS.each do |key|
        attrs[key] = "key #{rand(1000)}"
      end
      attrs["notified_at"] = nil
      key = PachubeDataFormats::Key.new(attrs)

      key.attributes.should_not include("notified_at")
    end
  end

  describe "#attributes=" do
    it "should accept and save a hash of properties" do
      key = PachubeDataFormats::Key.new({})

      attrs = {}
      PachubeDataFormats::Key::ALLOWED_KEYS.each do |attr|
        value = "key #{rand(1000)}"
        attrs[attr] = value
        key.should_receive("#{attr}=").with(value)
      end
      key.attributes=(attrs)
    end
  end

  describe "#as_json" do
    it "should call the json generator" do
      options = {:include_blanks => true}
      key = PachubeDataFormats::Key.new
      key.should_receive(:generate_json).with(options).and_return({"permissions" => [:get, :put]})
      key.as_json(options).should == {"permissions" => [:get, :put]}
    end

    it "should accept *very* nil options" do
      key = PachubeDataFormats::Key.new
      key.should_receive(:generate_json).with({}).and_return({"permissions" => [:get, :put]})
      key.as_json(nil).should == {"permissions" => [:get, :put]}
    end
  end

  describe "#to_json" do
    before(:each) do
      @key_hash = { "scopes" => [{"permissions" => [:get, :put, :post], :resources => [{:feed_id => 504, :datastream_id => "0"}]}] }
    end

    it "should call #as_json" do
      key = PachubeDataFormats::Key.new(@key_hash)
      key.should_receive(:as_json).with(nil)
      key.to_json
    end

    it "should pass options through to #as_json" do
      key = PachubeDataFormats::Key.new(@key_hash)
      key.should_receive(:as_json).with({:crazy => "options"})
      key.to_json({:crazy => "options"})
    end

    it "should pass the output of #as_json to yajl" do
      key = PachubeDataFormats::Key.new(@key_hash)
      key.should_receive(:as_json).and_return({:awesome => "hash"})
      ::JSON.should_receive(:generate).with({:awesome => "hash"})
      key.to_json
    end
  end

end
