def feed_as_(format, options = {})
  # Default data
  # This data is taken from http://api.pachube.com/v2/feeds/504
  case format.to_s
  when 'hash'
    data = {
     "retrieved_at"=>Time.parse('2011-01-02'),
     "created_at"=>Time.parse('2011-01-01'),
     "title"=>"Pachube Office environment",
     "csv_version"=>"",
     "updated_at"=>Time.parse('2011-02-16'),
     "private"=>false,
     "owner"=>"hdr",
     "id"=>504,
     "icon"=>"",
     "website"=>"http://www.pachube.com/",
     "tags"=>["hq", "office"],
     "description"=>"Sensors in Pachube.com's headquarters.",
     "feed"=>"http://92.27.75.48/",
     "email"=>"",
     "datastreams" => [
       {
        "retrieved_at" => Time.parse('2011-01-02'),
        "max_value"=>658.0,
        "unit_type"=>"",
        "min_value"=>0.0,
        "unit_label"=>"",
        "value"=>"14",
        "id"=>"0",
        "tag_list"=>"humidity",
        "unit_symbol"=>""},
       {
        "retrieved_at" => Time.parse('2011-01-02'),
        "max_value"=>980.0,
        "unit_type"=>"",
        "min_value"=>0.0,
        "unit_label"=>"",
        "value"=>"813",
        "id"=>"1",
        "tag_list"=>"light level",
        "unit_symbol"=>""},
       {
        "retrieved_at" => Time.parse('2011-01-02'),
        "max_value"=>774.0,
        "unit_type"=>"",
        "min_value"=>158.0,
        "unit_label"=>"",
        "value"=>"318",
        "id"=>"2",
        "tag_list"=>"temperature",
        "unit_symbol"=>""},
       {
        "retrieved_at" => Time.parse('2011-01-02'),
        "max_value"=>0.0,
        "unit_type"=>"",
        "min_value"=>0.0,
        "unit_label"=>"",
        "value"=>"0",
        "id"=>"3",
        "tag_list"=>"door 1",
        "unit_symbol"=>""},
       {
        "retrieved_at" => Time.parse('2011-01-02'),
        "max_value"=>0.0,
        "unit_type"=>"",
        "min_value"=>0.0,
        "unit_label"=>"",
        "value"=>"0",
        "id"=>"4",
        "tag_list"=>"door 2",
        "unit_symbol"=>""},
       {
        "retrieved_at" => Time.parse('2011-01-02'),
        "max_value"=>40.0,
        "unit_type"=>"",
        "min_value"=>0.0,
        "unit_label"=>"",
        "value"=>"40",
        "id"=>"5",
        "tag_list"=>"failures",
        "unit_symbol"=>""},
       {
        "retrieved_at" => Time.parse('2011-01-02'),
        "max_value"=>32767.0,
        "unit_type"=>"",
        "min_value"=>-32768.0,
        "unit_label"=>"",
        "value"=>"15545",
        "id"=>"6",
        "tag_list"=>"successes",
        "unit_symbol"=>""}]
    }
  when 'json'
    data = {
      'title' => 'Pachube Office Environment',
      'status' => 'live',
      'updated' => '2011-02-16T16:21:01.834174Z',
      'tags' => ['hq', 'office'],
      'description' => 'Sensors in Pachube.com\'s headquarters.',
      'title' => 'Pachube Office environment',
      'website' => 'http://www.pachube.com/',
      'private' => 'false',
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
           'tags' => ['temperature'],
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

# Helpful method which allows us to do
#    output_string.parse_feed_as_("json"),
# or output_string.parse_feed_as_("xml")
# and get back a nicely formatted hash
# for comparison in tests
class Object
  def parse_feed_as_(format, options = {})
    case format.to_s
    when 'hash'
      self
    when 'json'
      JSON.parse(self)
    else
      raise "#{format} undefined"
    end
  end
end
