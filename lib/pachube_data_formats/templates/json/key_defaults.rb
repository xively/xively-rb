module PachubeDataFormats
  module Templates
    module JSON
      module KeyDefaults
        def generate_json(options={})
          template = Template.new(self, :json)
          template.key do
            {
              :id => id,
              :expires_at => expires_at,
              :feed_id => feed_id,
              :api_key => key,
              :permissions => permissions,
              :private_access => private_access,
              :referer => referer,
              :source_ip => source_ip,
              :datastream_id => datastream_id,
              :user => user,
              :label => label
            }
          end
          template.output! options
        end
      end
    end
  end
end

