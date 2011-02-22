module PachubeDataFormats
  class Datastream
    ALLOWED_KEYS = %w(id max_value min_value retrieved_at tag_list unit_label unit_symbol unit_type value)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    attr_accessor :id
    def initialize(input)
      if input.is_a? Hash
        self.attributes = DatastreamFormats::PachubeHash.parse(input)
      else
        self.attributes = DatastreamFormats::PachubeJSON.parse(input)
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
      DatastreamFormats::PachubeHash.generate(attributes)
    end

    def to_json(options = {})
      attrs = options[:version] ? attributes.clone.merge("version" => "1.0.0") : attributes.clone
      ::JSON.generate DatastreamFormats::PachubeJSON.generate(attrs)
    end
  end
end

