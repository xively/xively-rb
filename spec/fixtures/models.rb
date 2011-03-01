class Feed < ActiveRecord::Base
  is_pachube_data_format :feed 
  has_many :datastreams
end

class Datastream < ActiveRecord::Base
  is_pachube_data_format :datastream, {:id => :stream_id}
  belongs_to :feed
end
