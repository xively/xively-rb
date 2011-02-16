module PachubeDataFormats
  class Feed
    ALLOWED_KEYS = %w(datastreams status updated tags description title website private version id location feed)
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

