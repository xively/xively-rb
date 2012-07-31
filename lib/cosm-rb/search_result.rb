module Cosm
  class SearchResult
    ALLOWED_KEYS = %w(totalResults startIndex itemsPerPage results)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    include Cosm::Templates::JSON::SearchResultDefaults
    include Cosm::Templates::XML::SearchResultDefaults
    include Cosm::Parsers::JSON::SearchResultDefaults

    @@feed_class = Cosm::Feed

    def initialize(input = {})
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

    def results=(array)
      return unless array.is_a?(Array)
      @results = []
      array.each do |feed|
        if feed.is_a?(@@feed_class)
          @results << feed
        elsif feed.is_a?(Hash)
          @results << @@feed_class.new(feed)
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

