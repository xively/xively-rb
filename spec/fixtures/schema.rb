ActiveRecord::Schema.define(:version => 0) do
  create_table "feeds", :force => true do |t| 
    t.string   "feed" 
    t.string   "creator"
    t.string   "title" 
    t.string   "website" 
    t.string   "icon" 
    t.text     "description" 
    t.datetime "updated" 
    t.string   "email"
    t.boolean  "private", :default => false 
    t.string   "tags" 
    t.string   "location_disposition" 
    t.string   "location_domain" 
    t.string   "location_ele" 
    t.string   "location_exposure" 
    t.string   "location_lat" 
    t.string   "location_lon" 
    t.string   "location_name" 
  end 
 
  create_table "datastreams", :force => true do |t|
    t.string   "stream_id", :null => false
    t.integer  "feed_id", :null => false
    t.string   "feed_creator"
    t.string   "current_value"
    t.float    "min_value"
    t.float    "max_value"
    t.string   "unit_label"
    t.string   "unit_type", :limit => 25
    t.string   "unit_symbol", :limit => 50
    t.string   "tags"
    t.datetime "updated"
  end

  create_table "datapoints", :force => true do |t|
    t.datetime "at"
    t.string   "value"    
    t.integer  "datastream_id", :null => false
  end    
end

