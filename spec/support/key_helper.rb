def key_as_(format, options = {})
  # Default data
  # This data is based on http://api.pachube.com/v2/feeds/504
  case format.to_s
  when 'hash', 'json'
    data = { "id" => 40, "key" => "abcdefghasdfaoisdj109usasdf0a9sf", "label" => "Our awesome label",
      "user" => "lebreeze", "expires_at" => 12345, "permissions" => [
        { "source_ip" => "127.0.0.1", "referer" => "http://www.pachube.com",
          "access_types" => %w(get put post delete), "private_access" => true,
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
  <permissions>
    <permission>
      <referer>http://www.pachube.com</referer>
      <source-ip>127.0.0.1</source-ip>
      <access-types>
        <access-type>GET</access-type>
        <access-type>PUT</access-type>
        <access-type>POST</access-type>
        <access-type>DELETE</access-type>
      </access-types>
      <private-access>true</private-access>
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
    { "key" => data }.to_json
  when 'xml'
    data
  else
    raise "#{format} undefined"
  end
end

