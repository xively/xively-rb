module PachubeDataFormats
  class SearchResult
    ALLOWED_KEYS = %w(totalResults startIndex itemsPerPage feeds)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    # include PachubeDataFormats::Templates::FeedJSONDefaults
    include PachubeDataFormats::Templates::SearchResultXMLDefaults
    include PachubeDataFormats::Templates::SearchResultJSONDefaults
    # include PachubeDataFormats::Parsers::FeedJSONDefaults
    # include PachubeDataFormats::Parsers::FeedXMLDefaults

    def initialize(input)
      self.attributes = input
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

    def feeds=(array)
      return unless array.is_a?(Array)
      @feeds = []
      array.each do |feed|
        if feed.is_a?(Feed)
          @feeds << feed
        elsif feed.is_a?(Hash)
          @feeds << Feed.new(feed)
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


