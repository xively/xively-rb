module PachubeDataFormats
  module Templates
    module JSON
      module KeyDefaults
        def generate_json(options={})
          template = Template.new(self, :json)
          template.id
          template.expires_at
          template.feed_id
          template.api_key {key}
          template.permissions
          template.private_access
          template.referer
          template.source_ip
          template.datastream_id
          template.user
          template.output! options
        end
      end
    end
  end
end

