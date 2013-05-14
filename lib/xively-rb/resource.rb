module Xively
  class Resource
    ALLOWED_KEYS = %w(feed_id datastream_id datastream_trigger_id)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    include Validations

    def valid?
      pass = true
      if feed_id.blank? && datastream_id.blank? && datastream_trigger_id.blank?
        errors[:feed_id] = "Must supply at least one of feed_id (optionally with a datastream_id) or datastream_trigger_id"
        pass = false
      end

      if feed_id.blank? && !datastream_id.blank?
        errors[:feed_id] = ["can't be blank if we have supplied a datastream_id"]
        pass = false
      end

      return pass
    end

    def initialize(input = {})
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
      input.deep_stringify_keys!
      ALLOWED_KEYS.each { |key| self.send("#{key}=", input[key]) }
      return attributes
    end
  end
end
