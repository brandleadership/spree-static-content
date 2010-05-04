class StaticContentController < Spree::BaseController
  caches_action :show

  def index
    unless @page = Page.visible.find_by_slug(root_path)
      render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
    end
  end
  
  def show
    unless @page = Page.visible.find_by_slug(path)
      render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
    end
  end
  
  private
  def root_path
    @page = Page.find(:first, :root_page => 1)  
  end

  def path
    path = case params[:path]
    when Array
      '/' + params[:path].join("/")
    when String
      params[:path]
    when nil
      request.path
    end

    path
  end
end

