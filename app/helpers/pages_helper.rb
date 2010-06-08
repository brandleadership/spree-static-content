module PagesHelper

  def static_content_sidebar
    Page.sidebar_links
  end

  def static_content_help_navigation
    Page.help_links
  end

  def static_content_root_page
    Page.find_by_root_page(true)
  end

  def static_content_current_page?(page)
    page.slug.eql?request.env["PATH_INFO"]
  end

end