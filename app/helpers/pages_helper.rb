module PagesHelper

  def static_content_sidebar
    Page.visible.sidebar_links
  end

  def static_content_help_navigation
    Page.visible.help_links
  end

  def static_content_root_page
    Page.visible.find_by_root_page(true)
  end

  def static_content_current_page?(page)
    page.slug.eql?request.env["PATH_INFO"]
  end

end