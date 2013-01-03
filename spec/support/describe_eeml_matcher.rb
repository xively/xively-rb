RSpec::Matchers.define :describe_eeml_for_version do |eeml_version|
  match do |xml|
    attrs = xml.root
    case eeml_version
    when "0.5.1"
      attrs["version"].should == eeml_version
      attrs.namespace.href.should == "http://www.eeml.org/xsd/0.5.1"
      attrs["xsi:schemaLocation"].should == "http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"
    when "5"
      attrs["version"].should == eeml_version
      attrs.namespace.href.should == "http://www.eeml.org/xsd/005"
      attrs["xsi:schemaLocation"].should == "http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"
    else
      false
    end
  end

  failure_message_for_should do |xml|
    "expected #{xml} to describe eeml version #{eeml_version}"
  end
end


