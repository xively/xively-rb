module PachubeDataFormats
  module Templates
    module JSON
      module KeyDefaults
        def generate_json(options={})
          template = Template.new(self, :json)
          template.key do |k|
            if self.scopes
              s = self.scopes.collect { |s|
                if s.resources
                  res = s.resources.collect { |r|
                    {
                      :feed_id => r.feed_id,
                      :datastream_id => r.datastream_id,
                      :datastream_trigger_id => r.datastream_trigger_id
                    }.delete_if_nil_value
                  }
                end
                {
                  :referer => s.referer,
                  :source_ip => s.source_ip,
                  :private_access => s.private_access,
                  :label => s.label,
                  :minimum_interval => s.minimum_interval,
                  :permissions => s.permissions.collect { |p| p.to_s.downcase },
                  :resources => res
                }.delete_if_nil_value
              }
            end

            {
              :id => id,
              :expires_at => expires_at,
              :api_key => key,
              :user => user,
              :label => label,
              :scopes => s
            }
          end
          template.output! options
        end
      end
    end
  end
end

