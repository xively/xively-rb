def feed_as_(format, options = {})
  # Default data
  data = {
    :title => "Pachube Office Environment"
  }

  # Add extra options we passed
  if options[:with]
    options[:with].each do |field, value|
      data[field] = value
    end
  end

  # Return the feed in the requested format
  case format
  when 'json'
    data[:version] = "1.0.0"
    data.to_json
  else
    raise "#{format} undefined"
  end
end

