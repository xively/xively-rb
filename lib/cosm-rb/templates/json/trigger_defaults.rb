module Cosm
  module Templates
    module JSON
      module TriggerDefaults
        def generate_json(version = nil)
          {
            :id => self.id,
            :threshold_value => self.threshold_value,
            :notified_at => self.notified_at,
            :url => self.url,
            :trigger_type => self.trigger_type,
            :stream_id => self.stream_id,
            :environment_id => self.environment_id,
            :user => self.user,
          }.delete_if_nil_value
        end
      end
    end
  end
end

