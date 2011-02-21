ActiveRecord::Schema.define(:version => 0) do
  create_table "environments", :force => true do |t| 
    t.string   "feed" 
    t.string   "title" 
    t.string   "website" 
    t.string   "icon" 
    t.text     "description" 
    t.text     "feed_content" 
    t.datetime "created_at" 
    t.datetime "updated_at" 
    t.datetime "retrieved_at" 
    t.datetime "deleted_at" 
    t.integer  "owner_id", :null => false 
    t.string   "email"
    t.boolean  "feed_retrieved", :default => false 
    t.string   "mime_type", :limit => 30 
    t.boolean  "private", :default => false 
    t.boolean  "mapped", :default => false 
    t.string   "tag_list" 
    t.string   "csv_version" 
    t.string   "feed_content_hash", :limit => 40 
  end 
end

