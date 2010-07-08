class Array
  def only_files
    self.select{|f| f unless (File.directory?f or File.file?f) }
  end
end
  
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
    extension_dirs.each do |ext|
      Dir.entries("#{RAILS_ROOT}/vendor/extensions/#{ext}/app/views/layouts").only_files.collect{ |e| layouts << e.scan(/\w+/).first } if File.exist?("#{RAILS_ROOT}/vendor/extensions/#{ext}/app/views/layouts")
    end

    layouts
  end

  def available_templates
    templates = Hash.new
    extension_dirs.each do |ext|
      ext_dir = "#{RAILS_ROOT}/vendor/extensions/#{ext}/app/views/static_content_templates"
      Dir.entries(ext_dir).only_files.collect{ |e| templates[e] = 'static_content_templates/' + e[1..e.length] } if File.exist?(ext_dir)
    end

    templates
  end

  def add_child_link(name, f, method)
    fields = new_child_fields(f, method)
    link_to_function(name, h("insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\")"))
  end
  
  def remove_child_link(name, f)
    f.hidden_field(:_delete) + link_to_function(name, "remove_fields(this)")
  end

  private

  def new_child_fields(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f
    form_builder.fields_for(method, options[:object], :child_index => "new_#{method}") do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
    end
  end

  def extension_dirs
    Dir.entries(RAILS_ROOT + '/vendor/extensions/').only_files
  end

end