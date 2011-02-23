module PachubeDataFormats
  class Datastream
    ALLOWED_KEYS = %w(id max_value min_value retrieved_at tag_list unit_label unit_symbol unit_type value)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    include PachubeDataFormats::Templates::DatastreamDefaults

    def initialize(input)
      if input.is_a? Hash
        self.attributes = Formats::Datastreams::Hash.parse(input)
      else
        self.attributes = Formats::Datastreams::JSON.parse(input)
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

    def to_hash
      Formats::Datastreams::Hash.generate(attributes)
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

