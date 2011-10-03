def key_as_(format, options = {})
  # Default data
  case format.to_s
  when 'hash', 'json'
    data = { "id" => "d06eaf58f01c6e196e70", "name" => "Averager", "description" => "Description",
      "creator" => "devuser", "tags" => "energy", "contact_email" => "bob@example.com",
      "redirect_uri" => "http://example.com" }
  when 'xml'
    data = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<app>
  <id>d06eaf58f01c6e196e70</id>
  <name>Averager</name>
  <description>Description</description>
  <redirect-uri>http://example.com</redirect-uri>
  <contact-email>bob@example.com</contact-email>
  <tags>energy</tags>
  <creator>devuser</creator>
</app>
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
    { "app" => data }.to_json
  when 'xml'
    data
  else
    raise "#{format} undefined"
  end
end
