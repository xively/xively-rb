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

    # TODO: fix this
    key.scopes.each do |scope|

    end

    # key.scopes.should == xml.xpath("//scopes/scope").collect { |scope|
    # }

    # key.permissions.should == xml.xpath("//permissions").map { |permissions|
    #   permissions.xpath("//permission").map { |m| m.content.downcase }
    # }.flatten
    # key.private_access.should == xml.at_xpath("//private-access").content
    # key.referer.should == xml.at_xpath("//referer").content
    # key.source_ip.should == xml.at_xpath("//source-ip").content
    # key.datastream_id.should == xml.at_xpath("//datastream-id").content
    # key.feed_id.should == xml.at_xpath("//feed-id").content
  end

  def match_json_key(key, formatted_key)
    json = JSON.parse(formatted_key)["key"]
    key.id.should == json["id"]
    key.expires_at.should == json["expires_at"]
    key.key.should == json["api_key"]
    key.user.should == json["user"]
    key.label.should == json["label"]
    key.scopes.each_index do |index|
      scope = key.scopes[index]

      scope.referer.should == json["scopes"][index]["referer"]
      scope.source_ip.should == json["scopes"][index]["source_ip"]
      scope.label.should == json["scopes"][index]["label"]
      scope.permissions.should == json["scopes"][index]["permissions"]
      scope.private_access.should == json["scopes"][index]["private_access"]

      scope.resources.each_index do |res_index|
        resource = scope.resources[res_index]

        resource.feed_id.should == json["scopes"][index]["resources"][res_index]["feed_id"]
        resource.datastream_id.should == json["scopes"][index]["resources"][res_index]["datastream_id"]
        resource.datastream_trigger_id.should == json["scopes"][index]["resources"][res_index]["datastream_trigger_id"]
      end
    end
  end
end
