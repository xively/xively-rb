module PachubeDataFormats
  class Datastream
    ALLOWED_KEYS = %w(current_value datapoints feed_creator feed_id id max_value min_value tags unit_label unit_symbol unit_type updated)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    include PachubeDataFormats::Templates::JSON::DatastreamDefaults
    include PachubeDataFormats::Templates::XML::DatastreamDefaults
    include PachubeDataFormats::Parsers::JSON::DatastreamDefaults
    include PachubeDataFormats::Parsers::XML::DatastreamDefaults

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

    def datapoints
      @datapoints.nil? ? [] : @datapoints
    end

    def datapoints=(array)
      return unless array.is_a?(Array)
      @datapoints = []
      array.each do |datapoint|
        if datapoint.is_a?(Datapoint)
          @datapoints << datapoint
        elsif datapoint.is_a?(Hash)
          @datapoints << Datapoint.new(datapoint)
        end
      end
    end

    def as_json(options = {})
      options[:version] ||= "1.0.0"
      generate_json(options[:version])
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

