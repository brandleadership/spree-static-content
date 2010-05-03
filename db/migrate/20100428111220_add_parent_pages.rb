class AddParentPages < ActiveRecord::Migration
  def self.up
    change_table :pages do |t|
      t.integer :parent_page_id, :default => 0, :null => false
    end
  end

  def self.down
    change_table :pages do |t|
      t.remove :parent_page_id  
    end
  end
end