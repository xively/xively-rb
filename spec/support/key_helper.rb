def key_as_(format, options = {})
  # Default data
  # This data is based on http://api.cosm.com/v2/feeds/504
  case format.to_s
  when 'hash', 'json'
    data = { "id" => 40, "key" => "abcdefghasdfaoisdj109usasdf0a9sf", "label" => "Our awesome label",
      "user" => "lebreeze", "expires_at" => 12345, "private_access" => true,
      "permissions" => [
        { "source_ip" => "127.0.0.1", "referer" => "http://cosm.com",
          "access_methods" => %w(get put post delete),
          "resources" => [
            { "feed_id" => 424, "datastream_id" => "1" }
          ]
        }
      ]}
  when 'xml'
    data = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<key>
  <id>40</id>
  <api-key>abcdefghasdfaoisdj109usasdf0a9sf</api-key>
  <expires-at>12345</expires-at>
  <user>lebreeze</user>
  <label>Our awesome label</label>
  <private-access>true</private-access>
  <permissions>
    <permission>
      <referer>http://cosm.com</referer>
      <source-ip>127.0.0.1</source-ip>
      <access-methods>
        <access-method>GET</access-method>
        <access-method>PUT</access-method>
        <access-method>POST</access-method>
        <access-method>DELETE</access-method>
      </access-methods>
      <resources>
        <resource>
          <feed-id>424</feed-id>
          <datastream-id>1</datastream-id>
        </resource>
      </resources>
    </permission>
  </permissions>
</key>
XML
  end

  # Add extra options we passed
  if options[:with]
    options[:with].each do |field, value|
      data[field.to_s] = value
    end
  end

  # Remove options we don't need
  if options[:except]
    options[:except].each do |field,_|
      data.delete(field.to_s)
    end
  end

  # Return the feed in the requested format
  case format.to_s
  when 'hash'
    data
  when 'json'
    MultiJson.dump({ "key" => data })
  when 'xml'
    data
  else
    raise "#{format} undefined"
  end
end

