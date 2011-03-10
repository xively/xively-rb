def feed_as_(format, options = {})
  # Default data
  # This data is based on http://api.pachube.com/v2/feeds/504
  case format.to_s
  when 'hash'
    data = {
      "updated"=>Time.parse('2011-01-02'),
      "title"=>"Pachube Office Environment",
      "private"=>false,
      "id"=>504,
      "icon"=>"http://pachube.com/logo.png",
      "website"=>"http://pachube.com",
      "tags" => "kittens , sofa, aardvark",
      "description"=>"Sensors in Pachube.com's headquarters.",
      "feed" => "http://test.host/testfeed.html?random=890299&rand2=91",
      "email"=>"abc@example.com",
      "status"=>"live",
      "creator"=>"http://pachube.com/users/skeletor",
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
        "unit_symbol"=>""},
        {
        "updated" => Time.parse('2011-01-02'),
        "max_value"=>980.0,
        "unit_type"=>"",
        "min_value"=>0.0,
        "unit_label"=>"",
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
        "unit_symbol"=>""},
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
        "tags"=>"failures",
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
  else
    raise "#{format} undefined"
  end
end

def feed_as_json(version)
  case version
  when "1.0.0"
    {
      'title' => 'Pachube Office Environment',
      'status' => 'live',
      'updated' => '2011-02-16T16:21:01.834174Z',
      'tags' => ['hq', 'office'],
      'description' => 'Sensors in Pachube.com\'s headquarters.',
      'website' => 'http://www.pachube.com/',
      'private' => 'false',
      'creator' => 'http://pachube.com/users/skeletor',
      'version' => '1.0.0',
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
        'feed' => 'http://api.pachube.com/v2/feeds/504.json',
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
          'id' => '2'
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
  when "0.6-alpha"
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
      "description" => "Sensors in Pachube.com's headquarters.",
      "title" => "Pachube Office environment",
      "website" => "http://www.pachube.com/",
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
      "feed" => "http://api.pachube.com/v2/feeds/504.json"
    }
  else
    raise "No such JSON version"
  end
end

