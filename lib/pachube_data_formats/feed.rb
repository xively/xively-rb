module PachubeDataFormats
  class Feed
    ALLOWED_KEYS = %w(creator datastreams description email feed icon id location_disposition location_domain location_ele location_exposure location_lat location_lon location_name private status tags title updated website)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    include PachubeDataFormats::Templates::FeedJSONDefaults
    include PachubeDataFormats::Templates::FeedXMLDefaults
    include PachubeDataFormats::Parsers::FeedDefaults

    def initialize(input)
      if input.is_a?(Hash)
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
      return if input.nil?
      ALLOWED_KEYS.each { |key| self.send("#{key}=", input[key]) }
      return attributes
    end

    def datastreams=(array)
      return unless array.is_a?(Array)
      @datastreams = []
      array.each do |datastream|
        if datastream.is_a?(Datastream)
          @datastreams << datastream
        elsif datastream.is_a?(Hash)
          @datastreams << Datastream.new(datastream)
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

  end
end


