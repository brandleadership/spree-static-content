module PagesHelper

  def static_content_sidebar
    Page.find(:all, :conditions => {:show_in_sidebar => 1 , :visible => 1}, :order => :position)
  end

  def static_content_help_navigation
    Page.find(:all, :conditions => {:show_in_help_navigation => 1 , :visible => 1}, :order => :position)
  end

  def static_content_root_page
    Page.find_by_root_page(true)
  end

  def static_content_current_page?(page)
    page.slug.eql?request.env["PATH_INFO"]
  end

end