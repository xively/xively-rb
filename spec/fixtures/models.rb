class Feed
  extend Xively::Base

  is_xively :feed
  attr_accessor :datastreams
  attr_accessor :feed
  attr_accessor :creator
  attr_accessor :title
  attr_accessor :website
  attr_accessor :icon
  attr_accessor :description
  attr_accessor :updated
  attr_accessor :email
  attr_accessor :private
  attr_accessor :tags
  attr_accessor :location_disposition
  attr_accessor :location_domain
  attr_accessor :location_ele
  attr_accessor :location_exposure
  attr_accessor :location_lat
  attr_accessor :location_lon
  attr_accessor :location_name

  def attributes
    attributes = {}
    Xively::Feed::ALLOWED_KEYS.each do |key|
      attributes[key] = self.send(key) if self.respond_to?(key)
    end
    attributes
  end
end

class Datastream
  extend Xively::Base

  is_xively :datastream, {:id => :stream_id}

  attr_accessor :feed
  attr_accessor :feed_id
  attr_accessor :datapoints
  attr_accessor :id
  attr_accessor :stream_id
  attr_accessor :feed_creator
  attr_accessor :current_value
  attr_accessor :min_value
  attr_accessor :max_value
  attr_accessor :unit_label
  attr_accessor :unit_type
  attr_accessor :unit_symbol
  attr_accessor :tags
  attr_accessor :updated

  def attributes
    attributes = {}
    Xively::Datastream::ALLOWED_KEYS.each do |key|
      attributes[key] = self.send(key) if self.respond_to?(key)
    end
    attributes
  end

end

class Datapoint
  extend Xively::Base

  is_xively :datapoint
  attr_accessor :datastream_id
  attr_accessor :at
  attr_accessor :value

  def attributes
    attributes = {}
    Xively::Datapoint::ALLOWED_KEYS.each do |key|
      attributes[key] = self.send(key) if self.respond_to?(key)
    end
    attributes
  end


end

