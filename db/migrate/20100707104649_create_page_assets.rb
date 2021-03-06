class CreatePageAssets < ActiveRecord::Migration
  def self.up
    create_table :page_assets do |t|
      t.string   "description"
      t.string   "attachment_file_name"
      t.string   "attachment_content_type"
      t.integer  "attachment_file_size"
      t.datetime "attachment_updated_at"
      t.integer  "position"
      t.integer  "page_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :page_assets
  end
end
