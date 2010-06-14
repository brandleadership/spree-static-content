class AddLocalizedTitle < ActiveRecord::Migration
  def self.up
    rename_column :pages, :title, "title_#{I18n.default_locale.to_s}".to_sym
    AVAILABLE_LOCALES.each do |lang|
      add_column :pages, "title_#{lang.first.sub('-','_')}".to_sym, :string unless lang.first.sub('-','_') == I18n.default_locale.to_s
    end
  end

  def self.down
    rename_column :pages, "title_#{I18n.default_locale.to_s}".to_sym, :title
    AVAILABLE_LOCALES.each do |lang|
      remove_column :pages, "title_#{lang.first.sub('-','_')}".to_sym unless lang.first.sub('-','_') == I18n.default_locale.to_s
    end
  end
end