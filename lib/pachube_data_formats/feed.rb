module PachubeDataFormats
  class Feed
    attr_accessor(:hash)

    def initialize(input)
      @hash = JSON.parse(input)
    end

    def to_json
      JSON.generate(@hash)
    end
  end
end

