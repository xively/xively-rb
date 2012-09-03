RSpec::Matchers.define :fully_represent_datastream do |format, formatted_datastream|
  match do |datastream|
    case format.to_sym
    when :xml
      match_xml_datastream(datastream, formatted_datastream)
    when :json
      match_json_datastream(datastream, formatted_datastream)
    when :csv
      match_csv_datastream(datastream, formatted_datastream)
    else
      raise "Unknown Datastream format: '#{format}'"
    end
  end

  failure_message_for_should do |datastream|
    "expected #{datastream} to fully represent #{formatted_datastream}"
  end

  description do
    "expected #{formatted_datastream.class} to be fully represented"
  end

  def match_xml_datastream(datastream, formatted_datastream)
    xml = Nokogiri.parse(formatted_datastream)
    case xml.root.attributes["version"].value
    when "0.5.1"
      environment = xml.at_xpath("//xmlns:environment")
      data = environment.at_xpath("xmlns:data")
      datastream.feed_id.should == environment.attributes["id"].value
      datastream.feed_creator.should == environment.attributes["creator"].value
      datastream.id.should == data.attributes["id"].value
      if (tags = data.xpath("xmlns:tag")).any?
        datastream.tags.should == tags.map(&:content).sort{|a,b| a.downcase<=>b.downcase}.join(',')
      end
      current_value = data.at_xpath("xmlns:current_value")
      datastream.current_value.should == current_value.content
      datastream.updated.should == current_value.attributes["at"].value if current_value.attributes["at"]
      datastream.min_value.should == data.at_xpath("xmlns:min_value").content
      datastream.max_value.should == data.at_xpath("xmlns:max_value").content
      unit = data.at_xpath("xmlns:unit")
      if unit
        datastream.unit_label.should == unit.content
        datastream.unit_type.should == unit.attributes["type"].value if unit.attributes["type"]
        datastream.unit_symbol.should == unit.attributes["symbol"].value if unit.attributes["symbol"]
      end
      datastream.datapoints.each do |point|
        dp = data.at_xpath("xmlns:datapoints").at_xpath("xmlns:value[@at=\"#{point.at}\"]")
        point.value.should == dp.content
      end
      true
    when "5"
      environment = xml.at_xpath("//xmlns:environment")
      data = environment.at_xpath("xmlns:data")
      datastream.feed_id.should == environment.attributes["id"].value
      datastream.feed_creator.should == "http://www.haque.co.uk"
      datastream.id.should == data.attributes["id"].value
      if (tags = data.xpath("xmlns:tag")).any?
        datastream.tags.should == tags.map(&:content).sort{|a,b| a.downcase<=>b.downcase}.join(',')
      end
      current_value = data.at_xpath("xmlns:value")
      datastream.current_value.should == current_value.content
      datastream.updated.should == xml.at_xpath("//xmlns:environment").attributes["updated"].value if xml.at_xpath("//xmlns:environment").attributes["updated"]
      datastream.min_value.should == current_value.attributes["minValue"].value if current_value.attributes["minValue"]
      datastream.max_value.should == current_value.attributes["maxValue"].value if current_value.attributes["maxValue"]
      unit = data.at_xpath("xmlns:unit")
      if unit
        datastream.unit_label.should == unit.content
        datastream.unit_type.should == unit.attributes["type"].value if unit.attributes["type"]
        datastream.unit_symbol.should == unit.attributes["symbol"].value if unit.attributes["symbol"]
      end
      true
    else
      false
    end
  end

  def match_json_datastream(datastream, formatted_datastream)
    json = MultiJson.load(formatted_datastream)
    case json['version']
    when '1.0.0'
      raise "Not implemented"
    else
      false
    end
  end

  def match_csv_datastream(datastream, formatted_datastream)
    datastream.current_value.to_s.should == formatted_datastream.strip
  end
end


