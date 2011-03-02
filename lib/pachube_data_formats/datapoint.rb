module PachubeDataFormats
  class Datapoint
    ALLOWED_KEYS = %w(at value)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    include PachubeDataFormats::Templates::DatapointJSONDefaults
    include PachubeDataFormats::Templates::DatapointXMLDefaults
    include PachubeDataFormats::Parsers::DatapointJSONDefaults
    include PachubeDataFormats::Parsers::DatapointXMLDefaults

    def initialize(input)
      if input.is_a? Hash
        self.attributes = input
      elsif input.strip.first == "{"
        self.attributes = from_json(input)
      else
        self.attributes = from_xml(input)
      end
    end

    def attributes
      h = {}
      ALLOWED_KEYS.each do |key|
        value = self.send(key)
        h[key] = value unless value.nil?
      end
      return h
    end

    def attributes=(input)
      ALLOWED_KEYS.each { |key| self.send("#{key}=", input[key]) }
    end

    def as_json(options = {})
      options[:version] ||= "1.0.0"
      datastream = generate_json(options[:version])
      datastream["version"] = options[:version] if options[:append_version]
      datastream
    end

    def to_json(options = {})
      ::JSON.generate as_json(options)
    end

    def to_xml(options = {})
      options[:version] ||= "0.5.1"
      generate_xml(options[:version])
    end
  end
end

