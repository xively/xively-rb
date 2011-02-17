module PachubeDataFormats
  class Feed
    ALLOWED_KEYS = %w(created_at csv_version datastreams description email feed icon id location owner private retrieved_at status tags title updated_at website)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    def initialize(input)
      self.hash = FeedParser::JSON.parse(input)
    end

    def hash
      h = {}
      ALLOWED_KEYS.each do |key|
        value = self.send(key)
        h[key] = value unless value.nil?
      end
      return h
    end

    def hash=(input)
      return if input.nil?
      ALLOWED_KEYS.each { |key| self.send("#{key}=", input[key]) }
      return hash
    end
    alias_method :to_hash, :hash

    def to_json
      JSON.generate(hash)
    end
  end
end

