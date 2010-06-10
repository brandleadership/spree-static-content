module Admin::PagesHelper

  def sorted_pages
    Page.find(:all, :order => :slug)
  end

  #
  # Normalize the locale from spree-i18n to rails-i18n
  # example: en-US => en_US
  #
  def normalize_locale(locale)
    locale = locale.to_s

    locale.tr('-','_')
  end
  
end