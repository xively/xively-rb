module Xively
  class Permission
    ALLOWED_KEYS = %w(label access_methods referer source_ip minimum_interval resources)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }
    NESTED_KEYS = %w(resources)

    include Validations

    def valid?
      pass = true
      if access_methods.nil? || access_methods.empty?
        errors[:access_methods] = ["can't be blank"]
        pass = false
      end

      resources.each do |resource|
        unless resource.valid?
          resource.errors.each do |attr, resource_errors|
            errors["resources_#{attr}".to_sym] = ([*errors["resources_#{attr}".to_sym]] | [*resource_errors]).compact
          end
          pass = false
        end
      end

      return pass
    end

    # Build an instance from a Hash only
    def initialize(input = {})
      self.attributes = input
    end

    def resources
      return [] if @resources.nil?
      @resources
    end

    def resources=(array)
      return unless array.is_a?(Array)
      @resources = []
      array.each do |resource|
        if resource.is_a?(Resource)
          @resources << resource
        elsif resource.is_a?(Hash)
          @resources << Resource.new(resource)
        end
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
      NESTED_KEYS.each { |key| self.send("#{key}=", input["#{key}_attributes"]) unless input["#{key}_attributes"].nil? }
      return attributes
    end
  end
end
