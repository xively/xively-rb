def search_result_as_(format, options = {})
  # Default data
  # This data is based on http://api.cosm.com/v2/feeds/504
  case format.to_s
  when 'hash'
    data = {
      "totalResults" => "10000",
      "itemsPerPage" => "100",
      "startIndex" => "0",
    "results" => [{
      "updated"=>Time.parse('2011-01-02'),
      "title"=>"Cosm Office Environment",
      "private"=>false,
      "id"=>504,
      "icon"=>"http://cosm.com/logo.png",
      "website"=>"http://cosm.com",
      "tags" => "kittens , sofa, aardvark",
      "description"=>"Sensors in cosm.com's headquarters.",
      "feed" => "http://test.host/testfeed.html?random=890299&rand2=91",
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
    }]
    }
  when 'json'
    data = search_result_as_json(options[:version] || "1.0.0")
  when 'xml'
    raise "Not implemented"
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

def search_result_as_json(version)
  case version
  when "1.0.0"
    {
    "totalResults" => "10000",
    "itemsPerPage" => "100",
    "startIndex" => "0",
    'results' => [{
      'title' => 'Cosm Office Environment',
      'status' => 'live',
      'updated' => '2011-02-16T16:21:01.834174Z',
      'tags' => ['hq', 'office'],
      'description' => 'Sensors in cosm.com\'s headquarters.',
      'website' => 'http://cosm.com/',
      'private' => 'false',
      'creator' => 'http://cosm.com/users/skeletor',
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
        'feed' => 'http://api.cosm.com/v2/feeds/504.json',
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
    }]
    }
  else
    raise "No such JSON version"
  end
end

