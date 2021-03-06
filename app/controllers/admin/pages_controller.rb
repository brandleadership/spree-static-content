class Admin::PagesController < Admin::BaseController
  resource_controller  
    
  update.response do |wants|
    wants.html { redirect_to collection_url }
  end
  
  update.after do
    expire_page :controller => 'static_content', :action => 'show', :path => @page.slug
    Rails.cache.delete('page_not_exist/'+@page.slug)
  end
  
  create.response do |wants|
    wants.html { redirect_to collection_url }
  end

  create.after do
    Rails.cache.delete('page_not_exist/'+@page.slug)
  end

  edit.before do
    @page.page_assets.build if @page.page_assets.empty? 
  end

  new_action.before do
    @page.page_assets.build
  end

  destroy.before do
    @page.page_assets.each do |attach|
      # Delete the files from the file system
      attach.attachment.destroy
    end
  end

  def new_sub
    @parent_page = Page.find(params[:id])
  end
  
end
