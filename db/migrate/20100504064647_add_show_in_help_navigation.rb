class AddShowInHelpNavigation < ActiveRecord::Migration
  def self.up
    change_table :pages do |t|
      t.boolean :show_in_help_navigation, :default=> false, :null=>false
    end
  end

  def self.down
    change_table :pages do |t|
       t.remove :show_in_help_navigation
    end
  end
end