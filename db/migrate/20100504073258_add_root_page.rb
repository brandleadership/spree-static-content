class AddRootPage < ActiveRecord::Migration
  def self.up
    change_table :pages do |t|
      t.boolean :root_page, :default => false, :null => false
    end
  end

  def self.down
    change_table :pages do |t|
       t.remove :root_page
    end
  end
end