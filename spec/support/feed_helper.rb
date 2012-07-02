def feed_as_(format, options = {})
  # Default data
  # This data is based on http://api.cosm.com/v2/feeds/504
  case format.to_s
  when 'hash'
    data = {
      "updated"=>Time.parse('2011-01-02'),
      "created"=>Time.parse('2011-01-01'),
      "title"=>"Cosm Office Environment",
      "private"=>false,
      "id"=>504,
      "icon"=>"http://cosm.com/logo.png",
      "website"=>"http://cosm.com",
      "tags" => "kittens , sofa, aardvark",
      "description"=>"Sensors in cosm.com's headquarters.",
      "feed" => "http://test.host/testfeed.html?random=890299&rand2=91",
      "auto_feed_url" => "http://test.host2/testfeed.xml?q=something",
      "owner_login" => "skeletor",
      "email"=>"abc@example.com",
      "status"=>"live",
      "creator"=>"http://cosm.com/users/skeletor",
      'location_domain' => 'physical',
      'location_lon' => -0.0807666778564453,
      'location_disposition' => 'fixed',
      'location_ele' => '23.0',
      'location_exposure' => 'indoor',
      'location_lat' => 51.5235375648154,
      'location_name' => 'office',
      "datastreams" => [
          {
        "updated" => Time.parse('2011-01-02'),
        "max_value"=>658.0,
        "unit_type"=>"",
        "min_value"=>0.0,
        "unit_label"=>"",
        "current_value"=>"14",
        "id"=>"0",
        "tags"=>"humidity,Temperature, freakin lasers",
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
        }],
        "unit_symbol"=>""},
        {
      "updated" => Time.parse('2011-01-02'),
        "max_value"=>980.0,
        "unit_type"=>"",
        "min_value"=>0.0,
        "unit_label"=>"label",
        "current_value"=>"813",
        "id"=>"1",
        "tags"=>"light level",
        "unit_symbol"=>""},
        {
        "updated" => Time.parse('2011-01-02'),
        "max_value"=>774.0,
        "unit_type"=>"some type",
        "min_value"=>158.0,
        "unit_label"=>"some measure",
        "current_value"=>"318",
        "id"=>"2",
        "tags"=>"Temperature",
        "unit_symbol"=>"some % symbol"},
        {
        "updated" => Time.parse('2011-01-02'),
        "max_value"=>0.0,
        "unit_type"=>"",
        "min_value"=>0.0,
        "unit_label"=>"",
        "current_value"=>"0",
        "id"=>"3",
        "tags"=>"door 1",
        "unit_symbol"=>"symbol"},
        {
        "updated" => Time.parse('2011-01-02'),
        "max_value"=>0.0,
        "unit_type"=>"",
        "min_value"=>0.0,
        "unit_label"=>"",
        "current_value"=>"0",
        "id"=>"4",
        "tags"=>"door 2",
        "unit_symbol"=>""},
        {
        "updated" => Time.parse('2011-01-02'),
        "max_value"=>40.0,
        "unit_type"=>"",
        "min_value"=>0.0,
        "unit_label"=>"",
        "current_value"=>"40",
        "id"=>"5",
        "unit_symbol"=>""},
        {
        "updated" => Time.parse('2011-01-02'),
        "max_value"=>32767.0,
        "unit_type"=>"",
        "min_value"=>-32768.0,
        "unit_label"=>"",
        "current_value"=>"15545",
        "id"=>"6",
        "tags"=>"successes",
        "unit_symbol"=>""}]
    }
  when 'json'
    data = feed_as_json(options[:version] || "1.0.0")
  when 'xml'
    data = feed_as_xml(options[:version] || "0.5.1", options[:except_node])
  when 'csv'
    data = feed_as_csv(options[:version] || "v2")
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
  when 'csv'
    data
  else
    raise "#{format} undefined"
  end
end

def feed_as_csv(version)
  case version.to_s
  when 'v1'
    '15,912,327,0,0,0,-30361'
  when 'v2'
    %Q{
0,2011-06-13T12:30:04.714629Z,15
1,2011-06-13T12:30:04.714629Z,905
2,2011-06-13T12:30:04.714629Z,326
3,2011-06-13T12:30:04.714629Z,0
4,2011-06-13T12:30:04.714629Z,0
5,2011-06-13T12:30:04.714629Z,0
6,2011-06-13T12:30:04.714629Z,-30362
}
  when 'unknown'
    '34,98'
  end
end

def feed_as_json(version)
  case version
  when "1.0.0"
    {
      'title' => 'Cosm Office Environment',
      'status' => 'live',
      'updated' => '2011-02-16T16:21:01.834174Z',
      'tags' => ['hq', 'office'],
      'description' => 'Sensors in cosm.com\'s headquarters.',
      'website' => 'http://www.cosm.com/',
      'private' => 'false',
      'creator' => 'http://cosm.com/users/skeletor',
      'version' => '1.0.0',
      'user' => {
        'login' => 'skeletor'
      },
      'id' => 504,
      'location' =>
      { 'domain' => 'physical',
        'lon' => -0.0807666778564453,
        'disposition' => 'fixed',
        'ele' => '23.0',
        'exposure' => 'indoor',
        'lat' => 51.5235375648154,
        'name' => 'office'
      },
        'feed' => 'http://api.cosm.com/v2/feeds/504.json',
        "auto_feed_url" => "http://test.host2/testfeed.xml?q=something",
        'datastreams' =>
      [
        {'min_value' => '0.0',
          'at' => '2011-02-16T16:21:01.834174Z',
          'tags' => ['humidity'],
          "unit" => {
        "symbol" => "cm",
        "label" => "cms",
        "type" => "metric"

      },

        'current_value' => '14',
        'max_value' => '658.0',
        'id' => '0'
      },
        {'min_value' => '0.0',
          'at' => '2011-02-16T16:21:01.834174Z',
          'tags' => ['light level'],
          'current_value' => '717',
          'max_value' => '980.0',
          'id' => '1'
      },
        {'min_value' => '158.0',
          'at' => '2011-02-16T16:21:01.834174Z',
          'tags' => ['Temperature'],
          'current_value' => '316',
          'max_value' => '774.0',
          'id' => '2',
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
          }]
      },
        {'min_value' => '0.0',
          'at' => '2011-02-16T16:21:01.834174Z',
          'tags' => ['door 1'],
          'current_value' => '0',
          'max_value' => '0.0',
          'id' => '3'
      },
        {'min_value' => '0.0',
          'at' => '2011-02-16T16:21:01.834174Z',
          'tags' => ['door 2'],
          'current_value' => '0',
          'max_value' => '0.0',
          'id' => '4'
      },
        {'min_value' => '0.0',
          'at' => '2011-02-16T16:21:01.834174Z',
          'tags' => ['failures'],
          'current_value' => '40',
          'max_value' => '40.0',
          'id' => '5'
      },
        {'min_value' => '-32768.0',
          'at' => '2011-02-16T16:21:01.834174Z',
          'tags' => ['successes'],
          'current_value' => '2638',
          'max_value' => '32767.0',
          'id' => '6'
      }
      ]
    }
  when "0.6-alpha", "0.6"
    {
      "datastreams" => [{
      "tags" => ["humidity"],
      "values" => [{
      "min_value" => "0.0",
      "recorded_at" => "2011-02-22T14:28:50Z",
      "value" => "129",
      "max_value" => "658.0",
    }],
    "id" => "0",
    "unit" => {
      "symbol" => "zen",
      "type" => "unity",
      "label" => "you can't pidgeon hole me"
    }

    },
      {
      "tags" => ["light level"],
      "values" => [{
      "min_value" => "0.0",
      "recorded_at" => "2011-02-22T14:28:50Z",
      "value" => "683",
      "max_value" => "980.0"
    }],
      "id" => "1"
    },
      {
      "tags" => ["Temperature"],
      "values" => [{
      "min_value" => "158.0",
      "recorded_at" => "2011-02-22T14:28:50Z",
      "value" => "314",
      "max_value" => "774.0"
    }],
      "id" => "2"
    },
      {
      "tags" => ["door 1"],
      "values" => [{
      "min_value" => "0.0",
      "recorded_at" => "2011-02-22T14:28:50Z",
      "value" => "0",
      "max_value" => "0.0"
    }],
      "id" => "3"
    },
      {
      "tags" => ["door 2"],
      "values" => [{
      "min_value" => "0.0",
      "recorded_at" => "2011-02-22T14:28:50Z",
      "value" => "0",
      "max_value" => "0.0"
    }],
      "id" => "4"
    },
      {
      "tags" => ["failures"],
      "values" => [{
      "min_value" => "0.0",
      "recorded_at" => "2011-02-22T14:28:50Z",
      "value" => "40",
      "max_value" => "40.0"
    }],
      "id" => "5"
    },
      {
      "tags" => ["successes"],
      "values" => [{
      "min_value" => "-32768.0",
      "recorded_at" => "2011-02-22T14:28:50Z",
      "value" => "31680",
      "max_value" => "32767.0"
    }],
      "id" => "6"
    }],
      "status" => "live",
      "updated" => "2011-02-22T14:28:50.590716Z",
      "description" => "Sensors in cosm.com's headquarters.",
      "title" => "Cosm Office environment",
      "website" => "http://www.cosm.com/",
      "version" => "0.6-alpha",
      "id" => 504,
      "location" => {
      "domain" => "physical",
      "lon" => -0.0807666778564453,
      "disposition" => "fixed",
      "ele" => "23.0",
      "exposure" => "indoor",
      "lat" => 51.5235375648154,
      "name" => "office"
    },
      "feed" => "http://api.cosm.com/v2/feeds/504.json"
    }
  else
    raise "No such JSON version"
  end
end

def feed_as_xml(version, except_node = nil)

  case version
  when "0.5.1"
    if except_node == :location
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://test.host/users/fred"> 
    <title>Cosm Office environment</title> 
    <feed>http://test.host/v2/feeds/2357.xml</feed> 
    <auto_feed_url>http://test.host2/testfeed.xml?q=something</auto_feed_url>
    <status>frozen</status> 
    <description>meh</description> 
    <website>http://alpha.com</website> 
    <email>fred@example.com</email> 
    <private>true</private> 
    <tag>jag</tag> 
    <tag>lag</tag> 
    <tag>mag</tag> 
    <tag>tag</tag> 
    <user>
      <login>fred</login>
    </user>
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <current_value at="2011-02-16T16:21:01.834174Z">14</current_value> 
      <max_value>658</max_value>
      <min_value>54</min_value>
      <unit type="derivedSI" symbol="A">Alpha</unit> 
      <datapoints> 
        <value at="2011-03-02T15:59:56.895922Z">1</value> 
        <value at="2011-03-02T16:00:07.188648Z">1</value> 
        <value at="2011-03-02T16:00:18.416500Z">2</value> 
      </datapoints>
    </data> 
    <data id="1">
      <current_value at="2011-02-16T16:21:01.834174Z">14444</current_value> 
      <unit>Alpha</unit> 
    </data> 
    <data id="two">
      <max_value>1004</max_value> 
      <current_value at="2011-02-16T16:21:01.834174Z">14344</current_value> 
      <unit type="derivedSI">Alpha</unit> 
      <datapoints> 
        <value at="2011-03-02T16:00:18.416500Z">2</value> 
      </datapoints>
    </data> 
  </environment> 
</eeml>
XML
    elsif except_node == :unit
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://test.host/users/fred"> 
    <title>Cosm Office environment</title> 
    <feed>http://test.host/v2/feeds/2357.xml</feed> 
    <status>frozen</status> 
    <description>meh</description> 
    <website>http://alpha.com</website> 
    <email>fred@example.com</email> 
    <private>true</private> 
    <tag>jag</tag> 
    <tag>lag</tag> 
    <tag>mag</tag> 
    <tag>tag</tag> 
    <location domain="physical" exposure="indoor" disposition="fixed"> 
      <name>house</name> 
      <lat>53.3308729830171</lat> 
      <lon>111.796875</lon> 
      <ele>2000</ele> 
    </location> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <current_value at="2011-02-16T16:21:01.834174Z">14</current_value> 
      <max_value>658</max_value>
      <min_value>54</min_value>
      <datapoints> 
        <value at="2011-03-02T15:59:56.895922Z">1</value> 
        <value at="2011-03-02T16:00:07.188648Z">1</value> 
        <value at="2011-03-02T16:00:18.416500Z">2</value> 
      </datapoints>
    </data> 
    <data id="1">
      <current_value at="2011-02-16T16:21:01.834174Z">14444</current_value> 
    </data> 
    <data id="two">
      <max_value>1004</max_value> 
      <current_value at="2011-02-16T16:21:01.834174Z">14344</current_value> 
      <datapoints> 
        <value at="2011-03-02T16:00:18.416500Z">2</value> 
      </datapoints>
    </data> 
  </environment> 
</eeml>
XML
    elsif except_node == :tag
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://test.host/users/fred"> 
    <title>Cosm Office environment</title> 
    <feed>http://test.host/v2/feeds/2357.xml</feed> 
    <status>frozen</status> 
    <description>meh</description> 
    <website>http://alpha.com</website> 
    <email>fred@example.com</email> 
    <private>true</private> 
    <location domain="physical" exposure="indoor" disposition="fixed"> 
      <name>house</name> 
      <lat>53.3308729830171</lat> 
      <lon>111.796875</lon> 
      <ele>2000</ele> 
    </location> 
    <data id="0"> 
      <current_value at="2011-02-16T16:21:01.834174Z">14</current_value> 
      <max_value>658</max_value>
      <min_value>54</min_value>
      <unit type="derivedSI" symbol="A">Alpha</unit> 
      <datapoints> 
        <value at="2011-03-02T15:59:56.895922Z">1</value> 
        <value at="2011-03-02T16:00:07.188648Z">1</value> 
        <value at="2011-03-02T16:00:18.416500Z">2</value> 
      </datapoints>
    </data> 
    <data id="1">
      <current_value at="2011-02-16T16:21:01.834174Z">14444</current_value> 
      <unit>Alpha</unit> 
    </data> 
    <data id="two">
      <max_value>1004</max_value> 
      <current_value at="2011-02-16T16:21:01.834174Z">14344</current_value> 
      <unit type="derivedSI">Alpha</unit> 
      <datapoints> 
        <value at="2011-03-02T16:00:18.416500Z">2</value> 
      </datapoints>
    </data> 
  </environment> 
</eeml>
XML

    else
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://test.host/users/fred"> 
    <title>Cosm Office environment</title> 
    <feed>http://test.host/v2/feeds/2357.xml</feed> 
    <status>frozen</status> 
    <description>meh</description> 
    <website>http://alpha.com</website> 
    <email>fred@example.com</email> 
    <private>true</private> 
    <tag>jag</tag> 
    <tag>lag</tag> 
    <tag>mag</tag> 
    <tag>tag</tag> 
    <location domain="physical" exposure="indoor" disposition="fixed"> 
      <name>house</name> 
      <lat>53.3308729830171</lat> 
      <lon>111.796875</lon> 
      <ele>2000</ele> 
    </location> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <current_value at="2011-02-16T16:21:01.834174Z">14</current_value> 
      <max_value>658</max_value>
      <min_value>54</min_value>
      <unit type="derivedSI" symbol="A">Alpha</unit> 
      <datapoints> 
        <value at="2011-03-02T15:59:56.895922Z">1</value> 
        <value at="2011-03-02T16:00:07.188648Z">1</value> 
        <value at="2011-03-02T16:00:18.416500Z">2</value> 
      </datapoints>
    </data> 
    <data id="1">
      <current_value at="2011-02-16T16:21:01.834174Z">14444</current_value> 
      <unit>Alpha</unit> 
    </data> 
    <data id="two">
      <max_value>1004</max_value> 
      <current_value at="2011-02-16T16:21:01.834174Z">14344</current_value> 
      <unit type="derivedSI">Alpha</unit> 
      <datapoints> 
        <value at="2011-03-02T16:00:18.416500Z">2</value> 
      </datapoints>
    </data> 
  </environment> 
</eeml>
XML
    end
  when "5"
    if except_node == :location
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="5" xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://test.host/users/fred"> 
    <title>Cosm Office environment</title> 
    <feed>http://test.host/v2/feeds/2357.xml</feed> 
    <status>frozen</status> 
    <description>meh</description> 
    <website>http://alpha.com</website> 
    <email>fred@example.com</email> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <value maxValue="658.0" minValue="658">14</value> 
      <unit type="derivedSI" symbol="A">Alpha</unit> 
    </data> 
    <data id="1">
      <value>14</value> 
      <unit>Alpha</unit> 
    </data> 
    <data id="two">
      <value maxValue="658.0">1004</value> 
      <unit type="derivedSI">Alpha</unit> 
    </data> 
  </environment> 
</eeml>
XML
    elsif except_node == :unit
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="5" xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://test.host/users/fred"> 
    <title>Cosm Office environment</title> 
    <feed>http://test.host/v2/feeds/2357.xml</feed> 
    <status>frozen</status> 
    <description>meh</description> 
    <website>http://alpha.com</website> 
    <email>fred@example.com</email> 
    <location domain="physical" exposure="indoor" disposition="fixed"> 
      <name>house</name> 
      <lat>53.3308729830171</lat> 
      <lon>111.796875</lon> 
      <ele>2000</ele> 
    </location> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <value maxValue="658.0" minValue="658">14</value> 
    </data> 
    <data id="1">
      <value>14</value> 
    </data> 
    <data id="two">
      <value maxValue="658.0">1004</value> 
    </data> 
  </environment> 
</eeml>
XML
    elsif except_node == :unit_attributes
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="5" xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://test.host/users/fred"> 
    <title>Cosm Office environment</title> 
    <feed>http://test.host/v2/feeds/2357.xml</feed> 
    <status>frozen</status> 
    <description>meh</description> 
    <website>http://alpha.com</website> 
    <email>fred@example.com</email> 
    <location domain="physical" exposure="indoor" disposition="fixed"> 
      <name>house</name> 
      <lat>53.3308729830171</lat> 
      <lon>111.796875</lon> 
      <ele>2000</ele> 
    </location> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <value maxValue="658.0" minValue="658">14</value> 
      <unit>Alpha</unit> 
    </data> 
    <data id="1">
      <value>14</value> 
      <unit>Alpha</unit> 
    </data> 
    <data id="two">
      <value maxValue="658.0">1004</value> 
      <unit>Alpha</unit> 
    </data> 
  </environment> 
</eeml>
XML
    elsif except_node == :value_attributes
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="5" xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://test.host/users/fred"> 
    <title>Cosm Office environment</title> 
    <feed>http://test.host/v2/feeds/2357.xml</feed> 
    <status>frozen</status> 
    <description>meh</description> 
    <website>http://alpha.com</website> 
    <email>fred@example.com</email> 
    <location domain="physical" exposure="indoor" disposition="fixed"> 
      <name>house</name> 
      <lat>53.3308729830171</lat> 
      <lon>111.796875</lon> 
      <ele>2000</ele> 
    </location> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <value>14</value> 
      <unit type="derivedSI" symbol="A">Alpha</unit> 
    </data> 
    <data id="1">
      <value>14</value> 
      <unit>Alpha</unit> 
    </data> 
    <data id="two">
      <value>1004</value> 
      <unit type="derivedSI">Alpha</unit> 
    </data> 
  </environment> 
</eeml>
XML
    elsif except_node == :tag
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="5" xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://test.host/users/fred"> 
    <title>Cosm Office environment</title> 
    <feed>http://test.host/v2/feeds/2357.xml</feed> 
    <status>frozen</status> 
    <description>meh</description> 
    <website>http://alpha.com</website> 
    <email>fred@example.com</email> 
    <location domain="physical" exposure="indoor" disposition="fixed"> 
      <name>house</name> 
      <lat>53.3308729830171</lat> 
      <lon>111.796875</lon> 
      <ele>2000</ele> 
    </location> 
    <data id="0"> 
      <value maxValue="658.0" minValue="658">14</value> 
      <unit type="derivedSI" symbol="A">Alpha</unit> 
    </data> 
    <data id="1">
      <value>14</value> 
      <unit>Alpha</unit> 
    </data> 
    <data id="two">
      <value maxValue="658.0">1004</value> 
      <unit type="derivedSI">Alpha</unit> 
    </data> 
  </environment> 
</eeml>
XML
    else
      xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<eeml xmlns="http://www.eeml.org/xsd/005" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="5" xsi:schemaLocation="http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"> 
 <environment updated="2011-02-16T16:21:01.834174Z" id="504" creator="http://test.host/users/fred"> 
    <title>Cosm Office environment</title> 
    <feed>http://test.host/v2/feeds/2357.xml</feed> 
    <status>frozen</status> 
    <description>meh</description> 
    <website>http://alpha.com</website> 
    <email>fred@example.com</email> 
    <location domain="physical" exposure="indoor" disposition="fixed"> 
      <name>house</name> 
      <lat>53.3308729830171</lat> 
      <lon>111.796875</lon> 
      <ele>2000</ele> 
    </location> 
    <data id="0"> 
      <tag>freakin lasers</tag> 
      <tag>humidity</tag> 
      <tag>Temperature</tag> 
      <value maxValue="658.0" minValue="658">14</value> 
      <unit type="derivedSI" symbol="A">Alpha</unit> 
    </data> 
    <data id="1">
      <value>14</value> 
      <unit>Alpha</unit> 
    </data> 
    <data id="two">
      <value maxValue="658.0">1004</value> 
      <unit type="derivedSI">Alpha</unit> 
    </data> 
  </environment> 
</eeml>
XML
    end
  else
    raise "Datastream as XML #{version} not implemented"
  end

end
