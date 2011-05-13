module PachubeDataFormats
  class Trigger
    ALLOWED_KEYS = %w(threshold_value user notified_at url trigger_type id environment_id stream_id)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    include PachubeDataFormats::Parsers::JSON::TriggerDefaults
    include PachubeDataFormats::Parsers::XML::TriggerDefaults

    include ActiveModel::Validations

    validates_presence_of :url
    validates_presence_of :stream_id
    validates_presence_of :environment_id
    validates_presence_of :user

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
  end
end


