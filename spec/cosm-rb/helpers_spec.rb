require 'spec_helper'

describe "Template helpers" do
  include Cosm::Helpers

  describe "#join_tags" do

    it "should just return the string if it already is one" do
      join_tags('help, me').should == 'help, me'
    end

    it "should convert an array into a string" do
      join_tags(['bag', 'jag', 'lag', 'tag']).should == 'bag,jag,lag,tag'
    end

    it "should sort the array" do
      join_tags(['zag', 'xag', 'Bag', 'aag']).should == 'aag,Bag,xag,zag'
    end
  end

  describe "#parse_tag_string" do
    it "should handle single tags" do
      parse_tag_string('tag').should == ['tag']
    end

    it "should handle multiple tags" do
      parse_tag_string('tag, bag ,lag,jag').should == ['bag', 'jag', 'lag', 'tag']
    end

    it "should handle complex tags" do
      string = 'apple, orange, "red room", "  I like space  ", "tennis, later"'
      parse_tag_string(string).should ==
        [
          "  I like space  ",
          "apple",
          "orange",
          "red room",
          "tennis, later"
        ]
    end

    it "should handle tags with escaped double quote" do
      string = 'apple, orange, "horse:height=2\"", "  I like space  ", "tennis, later", "\"quote\""'
      parse_tag_string(string).should ==
        [
          "  I like space  ",
          "\"quote\"",
          "apple",
          "horse:height=2\"",
          "orange",
          "tennis, later"
        ]
    end
  end
end

