RSpec::Matchers.define :fully_represent_datapoint do |format, formatted_datapoint|
  match do |datapoint|
    if format.to_sym == :xml
      match_xml_datapoint(datapoint, formatted_datapoint)
    end
  end

  failure_message_for_should do |datapoint|
    "expected #{datapoint} to fully represent #{formatted_datapoint}"
  end

  description do
    "expected #{formatted_datapoint.class} to be fully represented"
  end

  def match_xml_datapoint(datapoint, formatted_datapoint)
    xml = Nokogiri.parse(formatted_datapoint)
    case xml.root.attributes["version"].value
    when "0.5.1"
      environment = xml.at_xpath("//xmlns:environment")
      data = environment.at_xpath("xmlns:data")
      datapoint.value.should == data.at_xpath("xmlns:datapoints").at_xpath("xmlns:value").content
      datapoint.at.should == data.at_xpath("xmlns:datapoints").at_xpath("xmlns:value").attributes["at"].value
    else
      false
    end
  end
end


