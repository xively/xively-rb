module Cosm
  module Templates
    module JSON
      module KeyDefaults
        def generate_json(options={})
          if self.permissions
            s = self.permissions.collect { |s|
              if s.resources
                res = s.resources.collect { |r| { :feed_id => r.feed_id, :datastream_id => r.datastream_id, :datastream_trigger_id => r.datastream_trigger_id }.delete_if_nil_value
                }
              end
              {
                :referer => s.referer,
                :source_ip => s.source_ip,
                :label => s.label,
                :minimum_interval => s.minimum_interval,
                :access_methods => s.access_methods.collect { |a| a.to_s.downcase },
                :resources => res
              }
            }
          end
          output = {
            :key => {
              :id => id,
              :expires_at => expires_at.respond_to?(:iso8601) ? expires_at.iso8601(6) : expires_at,
              :api_key => key,
              :user => user,
              :label => label,
              :private_access => private_access,
              :permissions => s
            }
          }
          !options[:include_blank] ? output.delete_if_nil_value : output
        end
      end
    end
  end
end

