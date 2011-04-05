module PachubeDataFormats
  class Feed
    ALLOWED_KEYS = %w(creator datastreams description email feed icon id location_disposition location_domain location_ele location_exposure location_lat location_lon location_name private status tags title updated website)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    include PachubeDataFormats::Templates::JSON::FeedDefaults
    include PachubeDataFormats::Templates::XML::FeedDefaults
    include PachubeDataFormats::Templates::CSV::FeedDefaults
    include PachubeDataFormats::Parsers::JSON::FeedDefaults
    include PachubeDataFormats::Parsers::XML::FeedDefaults

    def initialize(input)
      if input.is_a?(Hash)
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

    def datastreams
      return [] if @datastreams.nil?
      @datastreams
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

    def to_xml(options = {})
      options[:version] ||= "0.5.1"
      generate_xml(options[:version])
    end

    def to_csv(options = {})
      options[:version] ||= "2"
      generate_csv(options.delete(:version), options)
    end

  end
end


