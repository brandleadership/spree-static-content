class Page < ActiveRecord::Base
  default_scope :order => "position ASC"

  validates_presence_of :title
  validates_presence_of :body, :if => :not_using_foreign_link?

  validates_uniqueness_of :root_page, :if => :root_page == 1
  
  named_scope :header_links, :conditions => ["show_in_header = ?", true], :order => 'position'
  named_scope :footer_links, :conditions => ["show_in_footer = ?", true], :order => 'position'
  named_scope :sidebar_links,:conditions => ["show_in_sidebar = ?", true], :order => 'position'
  
  named_scope :visible, :conditions => {:visible => true}

  def initialize(*args)
    super(*args)
    last_page = Page.last
    self.position = last_page ? last_page.position + 1 : 0
  end

  def before_save
    unless new_record?
      return unless prev_position = Page.find(self.id).position
      if prev_position > self.position
        Page.update_all("position = position + 1", ["? <= position AND position < ?", self.position, prev_position])
      elsif prev_position < self.position
        Page.update_all("position = position - 1", ["? < position AND position <= ?", prev_position,  self.position])
      end
    end

    self.slug = ( parent_page_id != 0 ? Page.find(parent_page_id).slug + slug_link : slug_link )

  end

  def link
    if self.parent_page_id.eql?(0)
      foreign_link.blank? ? slug_link : foreign_link
    else
      foreign_link.blank? ? Page.find(self.parent_page_id).link + slug_link : foreign_link
    end
  end

private
  def not_using_foreign_link?
    foreign_link.blank?
  end

  def slug_link
    ensure_slash_prefix normalize(title)
  end
  
  def ensure_slash_prefix(str)
    str.index('/') == 0 ? str : '/' + str
  end

  def normalize(slug_text)
    return '' if slug_text.nil? || slug_text == ''
    slug_text.
      gsub(/[\W]/u, ' ').
      strip.
      gsub(/\s+/u, '-').
      gsub(/-\z/u, '').
      downcase.
      to_s
  end
end