RSpec::Matchers.define :contain_datapoint_eeml_for_version do |eeml_version|
  match do |xml|
    hash = datapoint_as_(:hash)
    environment = xml.at_xpath("//xmlns:environment")
    datapoint = environment.at_xpath("//xmlns:data").at_xpath("xmlns:datapoints")
    value = datapoint.at_xpath("xmlns:value")
    value.content.should == hash["value"]
    value.attributes["at"].value.should == hash["at"].iso8601(6)
  end

  failure_message_for_should do |xml|
    "expected #{xml} to describe eeml version #{eeml_version}"
  end
end


