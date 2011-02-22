ActiveRecord::Schema.define(:version => 0) do
  create_table "feeds", :force => true do |t| 
    t.string   "feed" 
    t.string   "title" 
    t.string   "website" 
    t.string   "icon" 
    t.text     "description" 
    t.datetime "created_at" 
    t.datetime "updated_at" 
    t.datetime "retrieved_at" 
    t.integer  "owner_id", :null => false 
    t.string   "email"
    t.boolean  "feed_retrieved", :default => false 
    t.string   "mime_type", :limit => 30 
    t.boolean  "private", :default => false 
    t.string   "tag_list" 
    t.string   "csv_version" 
  end 
  
  create_table "owners", :force => true do |t|
    t.string   "login"
    t.string   "email"
  end

  create_table "datastreams", :force => true do |t|
    t.integer  "feed_id", :null => false
    t.string   "stream_id"
    t.string   "value"
    t.float    "min_value"
    t.float    "max_value"
    t.string   "unit_label"
    t.string   "unit_type", :limit => 25
    t.string   "unit_symbol", :limit => 50
    t.string   "tag_list"
    t.datetime "retrieved_at"
  end
end

