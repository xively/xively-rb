module PachubeDataFormats
  class Key
    class Scope
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

      ALLOWED_KEYS = %w(label permissions private_access referer source_ip minimum_interval resources)
      ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

      include Validations

      def valid?
        pass = true
        if permissions.nil? || permissions.empty?
          errors[:permissions] = ["can't be blank"]
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
        puts array.inspect
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
        return attributes
      end
    end

    ALLOWED_KEYS = %w(id key label user expires_at scopes)
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
      [:scopes, :user].each do |attr|
        if self.send(attr).blank?
          errors[attr] = ["can't be blank"]
          pass = false
        end
      end

      scopes.each do |scope|
        unless scope.valid?
          scope.errors.each do |attr, scope_errors|
            errors["scopes_#{attr}".to_sym] = ([*errors["scopes_#{attr}".to_sym]] | [*scope_errors]).compact
          end
          pass = false
        end
      end

      return pass
    end

    # Build an instance from either a Hash, a JSON string, or an XML document
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
      input.deep_stringify_keys!
      ALLOWED_KEYS.each { |key| self.send("#{key}=", input[key]) }
      return attributes
    end

    def as_json(options = nil)
      generate_json(options || {})
    end

    def to_json(options = nil)
      ::JSON.generate as_json(options)
    end

    def scopes
      return [] if @scopes.nil?
      @scopes
    end

    def scopes=(array)
      return unless array.is_a?(Array)
      @scopes = []
      array.each do |scope|
        if scope.is_a?(Scope)
          @scopes << scope
        elsif scope.is_a?(Hash)
          @scopes << Scope.new(scope)
        end
      end
    end
  end
end
