def datastream_as_(format, options = {})
  case format.to_s
  when 'hash'
    data = {
      "retrieved_at" => Time.parse('2011-01-02'),
      "max_value"=>658.0,
      "unit_type"=>"derived SI",
      "min_value"=>0.0,
      "unit_label"=>"percentage",
      "value"=>"14",
      "id"=>"0",
      "tag_list"=>"humidity,temperature   ,freakin lasers",
      "unit_symbol"=>"%"
    }
  when 'json'
    data = {
      'min_value' => '0.0',
      'at' => '2011-02-16T16:21:01.834174Z',
      'tags' => ['humidity', 'temperature', 'freakin lasers'],
      'current_value' => '14',
      'max_value' => '658.0',
      'id' => '0',
      "unit" => {
          "type" => "derived SI",
          "symbol" => "%",
          "label" => "percentage"
      }
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

