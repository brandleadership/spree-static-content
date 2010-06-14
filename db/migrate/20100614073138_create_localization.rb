class CreateLocalization < ActiveRecord::Migration
  def self.up
    rename_column :pages, :body, "body_#{I18n.default_locale.to_s}".to_sym
    AVAILABLE_LOCALES.each do |lang|
      add_column :pages, "body_#{lang.first.sub('-','_')}".to_sym, :text unless lang.first.sub('-','_') == I18n.default_locale.to_s
    end
  end

  def self.down
    rename_column :pages, "body_#{I18n.default_locale.to_s}".to_sym, :body
    AVAILABLE_LOCALES.each do |lang|
      remove_column :pages, "body_#{lang.first.sub('-','_')}".to_sym unless lang.first.sub('-','_') == I18n.default_locale.to_s
    end
  end
end