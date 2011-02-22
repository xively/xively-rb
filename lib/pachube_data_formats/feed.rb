module PachubeDataFormats
  class Feed
    ALLOWED_KEYS = %w(created_at csv_version datastreams description email feed icon id location private retrieved_at status tag_list title updated_at website)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    def initialize(input)
      if input.is_a?(Hash)
        self.attributes = Formats::Feeds::Hash.parse(input)
      else
        self.attributes = Formats::Feeds::JSON.parse(input)
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

    def to_json
      ::JSON.generate Formats::Feeds::JSON.generate(attributes.merge("version" => "1.0.0"))
    end

    def to_hash
      hash = Formats::Feeds::Hash.generate(attributes)
      hash["datastreams"] = datastreams.map(&:to_hash) if datastreams
      hash
    end
  end
end


