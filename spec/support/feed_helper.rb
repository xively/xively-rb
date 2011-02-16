def feed_as_(format, options = {})
  # Default data
  data = {
    'title' => "Pachube Office Environment"
  }

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
    data['version'] = "1.0.0"
    data.to_json
  else
    raise "#{format} undefined"
  end
end

class String
  def parse_feed_as_(format, options = {})
    case format.to_s
    when 'json'
      JSON.parse(self)
    else
      raise "#{format} undefined"
    end
  end
end
