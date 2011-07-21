module PachubeDataFormats
  class Key
    ALLOWED_KEYS = %w(expires_at feed_id id key permissions private_access referer source_ip datastream_id user)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    include PachubeDataFormats::Templates::JSON::KeyDefaults
    #include PachubeDataFormats::Templates::XML::KeyDefaults
    include PachubeDataFormats::Parsers::JSON::KeyDefaults
    include PachubeDataFormats::Parsers::XML::KeyDefaults

    # validates_presence_of :user
    # validates_presence_of :permissions

    include Validations

    def valid?
      pass = true
      [:permissions, :user].each do |attr|
        if self.send(attr).blank?
          errors[attr] = ["can't be blank"]
          pass = false
        end
      end
      return pass
    end

    def initialize(input = {})
      if input.is_a?(Hash)
        self.attributes = input
      elsif input.strip[0...1].to_s == "{"
        self.attributes = from_json(input)
      else
        self.attributes = from_xml(input)
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

    def as_json(options = {})
      generate_json
    end

    def to_json(options = {})
      ::JSON.generate as_json(options)
    end
  end
end
