module PagesHelper

  def static_content_sidebar
    Page.visible.sidebar_links
  end

  def static_content_help_navigation
    Page.visible.help_links
  end

  def static_content_root_page
    page = Page.visible.find_by_root_page(true)

    page == nil ? Page.new : page
  end

  def static_content_current_page?(page)
    page.link.eql?request.env["PATH_INFO"]
  end

  def static_content_current_page_in_path?(page)
    request.env["PATH_INFO"].include?page.link
  end

  def static_content_search(params)
    Page.search(params)
  end

  def in_shop?
    false if Page.find_by_link(request.env["PATH_INFO"])
  rescue
    true
  end

  def site_title
    Spree::Config[:site_name]
  end

end