class Owner < ActiveRecord::Base
  has_many :feeds
end

class Feed < ActiveRecord::Base
  is_pachube_data_format :feed
  belongs_to :owner
  has_many :datastreams
end

class Datastream < ActiveRecord::Base
  belongs_to :feed
end
