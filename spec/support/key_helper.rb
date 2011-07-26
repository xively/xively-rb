def key_as_(format, options = {})
  # Default data
  # This data is based on http://api.pachube.com/v2/feeds/504
  case format.to_s
  when 'hash'
    data = {"source_ip"=>"127.0.0.1", "referer"=>"http://www.pachube.com", "permissions"=>%w(get put post delete), "key"=>"abcdefghasdfaoisdj109usasdf0a9sf", "id"=>40, "datastream_id"=>"1", "feed_id"=>424, "expires_at" => 12345, "private_access" => true, "user"=>"lebreeze", "label" => "Our awesome label"}
  when 'json'
    data = {"key" => {"source_ip"=>"127.0.0.1", "referer"=>"http://www.pachube.com", "permissions"=>%w(get put post delete), "api_key"=>"abcdefghasdfaoisdj109usasdf0a9sf", "id"=>40, "datastream_id"=>"1", "feed_id"=>424, "expires_at" => 12345, "private_access" => true, "user"=>"lebreeze", "label" => "Our awesome label"}}
  when 'xml'
    data = <<XML
<?xml version="1.0" encoding="UTF-8"?> 
<key> 
  <id type="integer">40</id> 
  <api-key>abcdefghasdfaoisdj109usasdf0a9sf</api-key>
  <referer>http://www.pachube.com</referer>
  <source-ip>127.0.0.1</source-ip>
  <expires-at>12345</expires-at>
  <feed-id type="integer">424</feed-id> 
  <datastream-id>1</datastream-id> 
  <private-access>true</private-access>
  <permissions>
    <permission>GET</permission>
    <permission>PUT</permission>
    <permission>POST</permission>
    <permission>DELETE</permission>
  </permissions>
  <user>lebreeze</user> 
  <label>Our awesome label</label>
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
    data.to_json
  when 'xml'
    data
  else
    raise "#{format} undefined"
  end
end

