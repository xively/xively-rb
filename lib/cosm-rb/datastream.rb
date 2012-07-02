module Cosm
  class Datastream
    ALLOWED_KEYS = %w(feed_id id feed_creator current_value datapoints max_value min_value tags unit_label unit_symbol unit_type updated datapoints_function)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }
    VALID_UNIT_TYPES = %w(basicSI derivedSI conversionBasedUnits derivedUnits contextDependentUnits)

    include Cosm::Helpers
    include Cosm::Templates::JSON::DatastreamDefaults
    include Cosm::Templates::XML::DatastreamDefaults
    include Cosm::Templates::CSV::DatastreamDefaults
    include Cosm::Parsers::JSON::DatastreamDefaults
    include Cosm::Parsers::XML::DatastreamDefaults
    include Cosm::Parsers::CSV::DatastreamDefaults

    include Validations

    def valid?
      pass = true
      [:id].each do |attr|
        if self.send(attr).blank?
          errors[attr] = ["can't be blank"]
          pass = false
        end
      end
      if !unit_type.blank?
        if !VALID_UNIT_TYPES.include?(unit_type)
          errors[:unit_type] = ["is not a valid unit_type (pick one from #{VALID_UNIT_TYPES.join(', ')} or leave blank)"]
          pass = false
        end
      end
      if current_value && current_value.length > 255
        errors[:current_value] = ["is too long (maximum is 255 characters)"]
        pass = false
      end
      if tags
        self.tags = join_tags(self.tags)
        if tags && tags.length > 255
          errors[:tags] = ["is too long (maximum is 255 characters)"]
          pass = false
        end
      end

      stream_id_regexp = RUBY_VERSION.to_f >= 1.9 ? /\A[\p{L}\w\-\+\.]+\Z/u : /\A[\w\-\+\.]+\Z/u

      unless self.id =~ stream_id_regexp
        errors[:id] = ["is invalid"]
        pass = false
      end
      if self.id.blank?
        errors[:id] = ["can't be blank"]
        pass = false
      end

      unless self.feed_id.to_s =~ /\A\d*\Z/
        errors[:feed_id] = ["is invalid"]
        pass = false
      end

      return pass
    end

    def initialize(input = {})
      if input.is_a? Hash
        self.attributes = input
      elsif input.strip[0...1].to_s == "{"
        self.attributes = from_json(input)
      elsif input.strip[0...1].to_s == "<"
        self.attributes = from_xml(input)
      else
        self.attributes = from_csv(input)
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
      input.deep_stringify_keys!
      ALLOWED_KEYS.each { |key| self.send("#{key}=", input[key]) }
      return attributes
    end

    def datapoints
      @datapoints.nil? ? [] : @datapoints
    end

    def datapoints=(array)
      return unless array.is_a?(Array)
      @datapoints = []
      array.each do |datapoint|
        if datapoint.is_a?(Datapoint)
          @datapoints << datapoint
        elsif datapoint.is_a?(Hash)
          @datapoints << Datapoint.new(datapoint)
        end
      end
    end

    def as_json(options = {})
      options[:version] ||= "1.0.0"
      generate_json(options.delete(:version), options)
    end

    def to_json(options = {})
      ::JSON.generate as_json(options)
    end

    def to_xml(options = {})
      options[:version] ||= "0.5.1"
      generate_xml(options.delete(:version), options)
    end

    def to_csv(options = {})
      options[:version] ||= "2"
      generate_csv(options.delete(:version), options)
    end
  end
end

