module Admin::PagesHelper

  def sorted_pages
    Page.find(:all, :order => :slug)
  end
  
end