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

  #
  # Shows all available layouts
  #
  def available_layouts
    layouts = Array.new
    Dir.entries(RAILS_ROOT + '/vendor/extensions/').select{|f| f unless (File.directory?f or File.file?f) }.each do |ext|
      Dir.entries("#{RAILS_ROOT}/vendor/extensions/#{ext}/app/views/layouts").select{|f| f if f.length > 2 }.collect{|e| layouts << e.scan(/\w+/).first} if File.exist?("#{RAILS_ROOT}/vendor/extensions/#{ext}/app/views/layouts")
    end

    layouts
  end
  
end