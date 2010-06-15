class AddLinkToShop < ActiveRecord::Migration
  def self.up
    add_column :pages, :link_to_shop, :boolean
  end

  def self.down
    remove_column :pages, :link_to_shop
  end
end