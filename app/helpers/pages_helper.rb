module PagesHelper

  def static_content_sidebar
    Page.find(:all, :conditions => {:show_in_sidebar => 1 , :visible => 1}, :order => :position)
  end

  def static_content_help_navigation
    Page.find(:all, :conditions => {:show_in_help_navigation => 1 , :visible => 1}, :order => :position)
  end
  
end