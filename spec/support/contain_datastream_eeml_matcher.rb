RSpec::Matchers.define :contain_datastream_eeml_for_version do |eeml_version|
  match do |xml|
    hash = datastream_as_(:hash)
    case eeml_version
    when "0.5.1"
      environment = xml.at_xpath("//xmlns:environment")
      environment.attributes["updated"].value.should == hash["updated"].iso8601(6)
      # TODO add creator and id (feed) to datastream wrapper
      datastream = environment.at_xpath("//xmlns:data")
      datastream.attributes["id"].value.should == hash["id"]
      tags = datastream.xpath("//xmlns:tag")
      hash["tags"].split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase}.each_with_index do |tag, index|
        tags[index].content.should == tag
      end
      current_value = datastream.at_xpath("//xmlns:current_value")
      current_value.content.should == hash["current_value"]
      current_value.attributes["at"].value.should == hash["updated"].iso8601(6)
      datastream.at_xpath("//xmlns:max_value").content.should == hash["max_value"].to_s
      datastream.at_xpath("//xmlns:min_value").content.should == hash["min_value"].to_s
      unit = datastream.at_xpath("//xmlns:unit")
      unit.content.should == hash["unit_label"]
      unit.attributes["type"].value.should == hash["unit_type"]
      unit.attributes["symbol"].value.should == hash["unit_symbol"]
    when "5"
      environment = xml.at_xpath("//xmlns:environment")
      environment.attributes["updated"].value.should == hash["updated"].iso8601
      # TODO add creator and id (feed) to datastream wrapper
      datastream = environment.at_xpath("//xmlns:data")
      datastream.attributes["id"].value.should == hash["id"]
      tags = datastream.xpath("//xmlns:tag")
      hash["tags"].split(',').map(&:strip).sort{|a,b| a.downcase <=> b.downcase}.each_with_index do |tag, index|
        tags[index].content.should == tag
      end
      current_value = datastream.at_xpath("//xmlns:value")
      current_value.content.should == hash["current_value"]
      current_value.attributes["minValue"].value.should == hash["min_value"].to_s
      current_value.attributes["maxValue"].value.should == hash["max_value"].to_s
      unit = datastream.at_xpath("//xmlns:unit")
      unit.content.should == hash["unit_label"]
      unit.attributes["type"].value.should == hash["unit_type"]
      unit.attributes["symbol"].value.should == hash["unit_symbol"]

    else
      false
    end
  end

  failure_message_for_should do |xml|
    "expected #{xml} to describe eeml version #{eeml_version}"
  end
end


