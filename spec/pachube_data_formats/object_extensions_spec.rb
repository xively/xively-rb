require 'spec_helper'

describe "Object extensions" do
  it "should define blank?" do
    Object.new.should respond_to(:blank?)
  end

  # Taken from ActiveSupport but not as good
  BLANK = [ nil, false, '', [], {} ]
  NOT_BLANK   = [ Object.new, true, 0, 1, 0.0, 'a', [nil], { nil => 0 } ]

  BLANK.each do |blank|
    it "should consider '#{blank}' as blank" do
      blank.should be_blank
    end
  end

  NOT_BLANK.each do |not_blank|
    it "should not consider '#{not_blank}' as blank" do
      not_blank.should_not be_blank
    end
  end
end

