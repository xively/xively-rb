module Cosm
  module Templates
    module JSON
      module TriggerDefaults
        def generate_json(version = nil)
          template = Template.new(self, :json)
          template.id
          template.threshold_value
          template.notified_at
          template.url
          template.trigger_type
          template.stream_id
          template.environment_id
          template.user
          template.output!
        end
      end
    end
  end
end

