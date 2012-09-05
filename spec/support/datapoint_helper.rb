def datapoint_as_(format, options = {})
  case format.to_s
  when 'hash'
    data = {
      "at" => Time.parse('2011-01-02'),
      "value" => "2000"
    }
  when 'json'
    data = {
      'at' => '2011-02-16T16:21:01.834174Z',
      'value' => "2000"
    }
  when 'xml'
    data = <<-XML
<?xml version="1.0" encoding="UTF-8"?> 
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
  <environment> 
    <data> 
      <datapoints> 
        <value at="2011-03-02T15:59:56.895922Z">2000</value> 
      </datapoints> 
    </data> 
  </environment> 
</eeml> 
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
    MultiJson.dump(data)
  when 'xml'
    data
  else
    raise "#{format} undefined"
  end
end
