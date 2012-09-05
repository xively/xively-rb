def datastream_as_(format, options = {})
  case format.to_s
  when 'hash'
    data = {
      "updated" => Time.parse('2011-01-02'),
      "max_value"=>658.0,
      "unit_type"=>"derived SI",
      "min_value"=>0.0,
      "unit_label"=>"percentage",
      "current_value"=>"14",
      "id"=>"0",
      "tags"=>"humidity,Temperature   ,freakin lasers",
      "unit_symbol"=>"%",
      "feed_id" => "24568",
      "feed_creator" => "Dennis",
      "datapoints" => [{
          "value" => "1",
          "at" => Time.parse("2011-03-02T15:59:56.895922Z")
      },
      {
          "value" => "1",
          "at" => Time.parse("2011-03-02T16:00:07.188648Z")
      },
      {
          "value" => "2",
          "at" => Time.parse("2011-03-02T16:00:18.416500Z")
      }]
    }
  when 'json'
    data = datastream_as_json(options[:version] || "1.0.0")
  when 'xml'
    data = datastream_as_xml(options[:version] || "0.5.1", options[:except_node], options[:omit_version])
  when 'csv'
    data = datastream_as_csv(options[:version] || "plain")
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
  when 'csv'
    data
  else
    raise "#{format} undefined"
  end

end

def datastream_as_json(version)
  case version
  when "1.0.0"
    {
      'min_value' => '0.0',
      'at' => '2011-02-16T16:21:01.834174Z',
      'tags' => ['humidity', 'Temperature', 'freakin lasers'],
      'current_value' => '14',
      'max_value' => '658.0',
      'datapoints_function' => 'average',
      "datapoints" => [{
          "value" => "1",
          "at" => "2011-03-02T15:59:56.895922Z"
      },
      {
          "value" => "1",
          "at" => "2011-03-02T16:00:07.188648Z"
      },
      {
          "value" => "2",
          "at" => "2011-03-02T16:00:18.416500Z"
      }],
      'id' => '0',
      "unit" => {
      "type" => "derived SI",
      "symbol" => "%",
      "label" => "percentage"
    },
      'version' => '1.0.0'
    }
  when "1.0.0-minimal"
    {
      "current_value" => "294",
      "max_value" => "697.0",
      "min_value" => "0.0",
      "id" => "1"
    }
  when "1.0.0-minimal_timestamp"
    {
      "current_value" => "294",
      "max_value" => "697.0",
      "min_value" => "0.0",
      "id" => "1",
      "at" => "2011-03-02T16:00:18.416500Z"
    }
  when "0.6-alpha"
    {
      "tags" => ["humidity"],
      "values" => [{
        "min_value" => "0.0",
        "recorded_at" => "2011-02-22T14:28:50Z",
        "value" => "129",
        "max_value" => "658.0"
      }],
      "id" => "0",
      "unit" => {
      "type" => "derived SI",
      "symbol" => "%",
      "label" => "percentage"
    },
      'version' => '0.6-alpha'
    }
  else
    raise "Datastream as JSON #{version} not implemented"
  end
end

def datastream_as_xml(version, except_node = nil, omit_version = true)
  case version
  when "0.5.1"
    if except_node == :tag
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?> 
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" #{omit_version ? '' : 'version="0.5.1"'} xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
  <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://appdev.loc:3000/users/occaecati"> 
    <data id="0"> 
      <current_value at="2011-02-16T16:21:01.834174Z">14</current_value> 
      <max_value>658.0</max_value> 
      <min_value>0.0</min_value> 
      <unit type="derivedSI" symbol="A">Alpha</unit> 
    </data> 
  </environment> 
</eeml>
XML
    elsif except_node == :unit
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?> 
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" #{omit_version ? '' : 'version="0.5.1"'} xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
  <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://appdev.loc:3000/users/occaecati"> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <current_value at="2011-02-16T16:21:01.834174Z">14</current_value> 
      <max_value>658.0</max_value> 
      <min_value>0.0</min_value> 
    </data> 
  </environment> 
</eeml>
XML
    elsif except_node == :unit_attributes
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?> 
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" #{omit_version ? '' : 'version="0.5.1"'} xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
  <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://appdev.loc:3000/users/occaecati"> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <current_value at="2011-02-16T16:21:01.834174Z">14</current_value> 
      <max_value>658.0</max_value> 
      <min_value>0.0</min_value> 
      <unit>Alpha</unit> 
    </data> 
  </environment> 
</eeml>
XML
    elsif except_node == :timestamps
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?> 
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" #{omit_version ? '' : 'version="0.5.1"'} xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
  <environment id="504" creator="http://appdev.loc:3000/users/occaecati"> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <current_value>14</current_value> 
      <max_value>658.0</max_value> 
      <min_value>0.0</min_value> 
      <unit type="derivedSI" symbol="A">Alpha</unit> 
    </data> 
  </environment> 
</eeml>
XML
    else
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?> 
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" #{omit_version ? '' : 'version="0.5.1"'} xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
  <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://appdev.loc:3000/users/occaecati"> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <current_value at="2011-02-16T16:21:01.834174Z">14</current_value> 
      <max_value>658.0</max_value> 
      <min_value>0.0</min_value> 
      <unit type="derivedSI" symbol="A">Alpha</unit> 
      <datapoints> 
        <value at="2011-03-02T15:59:56.895922Z">1</value> 
        <value at="2011-03-02T16:00:07.188648Z">1</value> 
        <value at="2011-03-02T16:00:18.416500Z">2</value> 
      </datapoints>
    </data> 
  </environment> 
</eeml>
XML
    end
  when "5"
    if except_node == :tag
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" #{omit_version ? '' : 'version="5"'} xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://appdev.loc:3000/users/occaecati"> 
    <data id="0"> 
      <value maxValue="658.0" minValue="658">14</value> 
      <unit type="derivedSI" symbol="A">Alpha</unit> 
    </data> 
  </environment> 
</eeml>
XML
    elsif except_node == :unit
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="5" xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://appdev.loc:3000/users/occaecati"> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <value maxValue="658.0" minValue="658">14</value> 
    </data> 
  </environment> 
</eeml>
XML
    elsif except_node == :unit_attributes
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" #{omit_version ? '' : 'version="5"'} xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://appdev.loc:3000/users/occaecati"> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <value maxValue="658.0" minValue="658">14</value> 
      <unit>Alpha</unit> 
    </data> 
  </environment> 
</eeml>
XML
    elsif except_node == :value_attributes
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="5" xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://appdev.loc:3000/users/occaecati"> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <value>14</value> 
      <unit type="derivedSI" symbol="A">Alpha</unit> 
    </data> 
  </environment> 
</eeml>
XML
    elsif except_node == :timestamps
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" #{omit_version ? '' : 'version="5"'} xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
 <environment id="504" creator="http://appdev.loc:3000/users/occaecati"> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <value maxValue="658.0" minValue="658">14</value> 
      <unit type="derivedSI" symbol="A">Alpha</unit> 
    </data> 
  </environment> 
</eeml>
XML
    else
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" #{omit_version ? '' : 'version="5"'} xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://appdev.loc:3000/users/occaecati"> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <value maxValue="658.0" minValue="658">14</value> 
      <unit type="derivedSI" symbol="A">Alpha</unit> 
    </data> 
  </environment> 
</eeml>
XML
    end
  else
    raise "Datastream as XML #{version} not implemented"
  end
end

def datastream_as_csv(version)
  case version
  when "timestamped"
    return "2011-02-16T16:21:01.834174Z,14"
  else
    return "14"
  end
end
