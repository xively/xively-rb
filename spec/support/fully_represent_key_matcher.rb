RSpec::Matchers.define :fully_represent_key do |format, formatted_key|
  match do |key|
    case format.to_sym
    when :xml
      match_xml_key(key, formatted_key)
    when :json
      match_json_key(key, formatted_key)
    end
  end

  failure_message_for_should do |key|
    "expected #{key.attributes.inspect} to fully represent #{formatted_key}"
  end

  description do
    "expected #{formatted_key.class} to be fully represented"
  end

  def match_xml_key(key, formatted_key)
    xml = Nokogiri.parse(formatted_key)
    key.id.should == xml.at_xpath("//id").content
    key.expires_at.should == xml.at_xpath("//expires-at").content
    key.feed_id.should == xml.at_xpath("//feed-id").content
    key.key.should == xml.at_xpath("//api-key").content
    key.permissions.should == xml.xpath("//permissions").map { |permissions|
      permissions.xpath("//permission").map { |m| m.content.downcase }
    }.flatten
    key.private_access.should == xml.at_xpath("//private-access").content
    key.referer.should == xml.at_xpath("//referer").content
    key.source_ip.should == xml.at_xpath("//source-ip").content
    key.datastream_id.should == xml.at_xpath("//datastream-id").content
    key.user.should == xml.at_xpath("//user").content
    key.label.should == xml.at_xpath("//label").content
  end
  
  def match_json_key(key, formatted_key)
    json = JSON.parse(formatted_key)
    key.id.should == json["id"]
    key.expires_at.should == json["expires_at"]
    key.feed_id.should == json["feed_id"]
    key.key.should == json["api_key"]
    key.permissions.should == json["permissions"].map(&:downcase)
    key.private_access.should == json["private_access"]
    key.referer.should == json["referer"]
    key.source_ip.should == json["source_ip"]
    key.datastream_id.should == json["datastream_id"]
    key.user.should == json["user"]
    key.label.should == json["label"]
  end
end
