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
    key.key.should == xml.at_xpath("//api-key").content
    key.user.should == xml.at_xpath("//user").content
    key.label.should == xml.at_xpath("//label").content
    key.private_access.should == xml.at_xpath("//private-access").content

    # TODO: fix this
    key.permissions.each_index do |permission_index|
      permission = key.permissions[permission_index]
      permission_node = xml.xpath("//permissions/permission")[permission_index]

      permission.label.should == permission_node.at_xpath("label").content
      permission.referer.should == permission_node.at_xpath("referer").content
      permission.source_ip.should == permission_node.at_xpath("source-ip").content
      permission.access_methods.should == permission_node.xpath("access-methods/access-method").collect { |a| a.content.downcase }

      permission.resources.each_index do |res_index|
        resource = permission.resources[res_index]
        resource_node = permission_node.xpath("resources/resource")[res_index]

        resource.feed_id.should == resource_node.at_xpath("feed-id").content
        resource.datastream_id.should == resource_node.at_xpath("datastream-id").content
        resource.datastream_trigger_id.should == resource_node.at_xpath("datastream-trigger-id").content
      end
    end
  end

  def match_json_key(key, formatted_key)
    json = MultiJson.load(formatted_key)["key"]
    key.id.should == json["id"]
    key.expires_at.should == json["expires_at"]
    key.key.should == json["api_key"]
    key.user.should == json["user"]
    key.label.should == json["label"]
    key.private_access.should == json["private_access"]
    key.permissions.each_index do |index|
      permission = key.permissions[index]

      permission.referer.should == json["permissions"][index]["referer"]
      permission.source_ip.should == json["permissions"][index]["source_ip"]
      permission.label.should == json["permissions"][index]["label"]
      permission.access_methods.should == json["permissions"][index]["access_methods"]

      permission.resources.each_index do |res_index|
        resource = permission.resources[res_index]

        resource.feed_id.should == json["permissions"][index]["resources"][res_index]["feed_id"]
        resource.datastream_id.should == json["permissions"][index]["resources"][res_index]["datastream_id"]
        resource.datastream_trigger_id.should == json["permissions"][index]["resources"][res_index]["datastream_trigger_id"]
      end
    end
  end
end
