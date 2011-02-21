module PachubeDataFormats
  class Feed
    ALLOWED_KEYS = %w(created_at csv_version datastreams description email feed icon id location owner private retrieved_at status tags title updated_at website)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    def initialize(input)
      if input.is_a?(Hash)
        self.attributes = FeedFormats::PachubeHash.parse(input)
      else
        self.attributes = FeedFormats::PachubeJSON.parse(input)
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
      ::JSON.generate FeedFormats::PachubeJSON.generate(attributes)
    end

    def to_hash
      hash = FeedFormats::PachubeHash.generate(attributes)
      hash["datastreams"] = datastreams.map(&:to_hash) if datastreams
      hash
    end
  end
end


