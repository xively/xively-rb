module PachubeDataFormats
  class Feed
    ALLOWED_KEYS = %w(title version)
    attr_accessor(:hash)

    def initialize(input)
      @hash = JSON.parse(input)

      # Whitelist all incoming keys
      @hash = @hash.reject { |key,_| !ALLOWED_KEYS.include? key }
    end

    def to_json
      JSON.generate(@hash)
    end
  end
end

