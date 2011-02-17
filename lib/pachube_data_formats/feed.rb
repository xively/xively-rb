module PachubeDataFormats
  class Feed
    ALLOWED_KEYS = %w(datastreams status updated tags description title website private version id location feed)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    def initialize(input)
      if input.is_a? Hash
        self.hash = input
      else
        self.hash = JSON.parse(input)
      end
    end

    def hash
      h = {}
      ALLOWED_KEYS.each { |key| h[key] = self.send(key) }
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

