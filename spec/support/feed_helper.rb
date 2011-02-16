def feed_as_(format)
  case format
  when 'json'
    File.read(File.dirname(__FILE__) + '/fixtures/json/1.0.0.json')
  else
    raise "#{format} undefined"
  end
end

