module PachubeDataFormats
  class Datastream
    ALLOWED_KEYS = %w(stream_id max_value min_value retrieved_at tag_list unit_label unit_symbol unit_type value)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    include PachubeDataFormats::Templates::DatastreamDefaults
    include PachubeDataFormats::Parsers::DatastreamDefaults

    def initialize(input)
      if input.is_a? Hash
        self.attributes = input
      else
        self.attributes = from_json(input)
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
  end
end

