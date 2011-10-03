module PachubeDataFormats
  class App
    ALLOWED_KEYS = %w(id name description app_id secret redirect_uri contact_email published tags creator_login updated)
    ALLOWED_KEYS.each { |key| attr_accessor(key.to_sym) }

    include PachubeDataFormats::Templates::JSON::AppDefaults
    include PachubeDataFormats::Templates::XML::AppDefaults
    include PachubeDataFormats::Parsers::JSON::AppDefaults
    include PachubeDataFormats::Parsers::XML::AppDefaults

    include Validations

    def valid?
      pass = true

      if name.blank?
        errors[:name] = ["can't be blank"]
        pass = false
      end

      return pass
    end

    def published?
      @published || false
    end
  end
end
