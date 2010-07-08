class AddHideTitle < ActiveRecord::Migration
  def self.up
    add_column :pages, :hide_title, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :hide_title
  end
end