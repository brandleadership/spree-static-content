class Page < ActiveRecord::Base
  include Admin::PagesHelper

  default_scope :order => "position ASC"

  has_one :parent_page, :foreign_key => 'parent_page_id', :class_name => 'Page'
  has_one :page, :through => :parent_page

  validates_presence_of ("title_"+I18n.default_locale.to_s).to_sym
  validates_presence_of ("body_"+I18n.default_locale.to_s).to_sym, :if => :not_using_foreign_or_shop_link?

  validates_uniqueness_of :root_page, :if => :root_page
  
  named_scope :header_links, :conditions => ["show_in_header = ?", true], :order => 'position'
  named_scope :footer_links, :conditions => ["show_in_footer = ?", true], :order => 'position'
  named_scope :sidebar_links,:conditions => ["show_in_sidebar = ?", true], :order => 'position'
  named_scope :help_links,   :conditions => ["show_in_help_navigation = ?", true], :order => 'position'
  
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

    self.foreign_link = '/products' if self.link_to_shop

    self.template = nil if self.template.empty?

  end

  def link
    if self.parent_page_id.eql?(0)
      foreign_link.blank? ? slug_link : foreign_link
    else
      foreign_link.blank? ? Page.find(self.parent_page_id).link + slug_link : foreign_link
    end
  end

  def sub_pages
    Page.find(:all, :conditions => ["parent_page_id = ?", self.id])
  end

  def sub_pages?
    if not Page.find(:all, :conditions => ["parent_page_id = ?", self.id]).empty?
      return true
    end
    false
  end

  #
  # Localize attributes
  #
  def method_missing(method, *arguments, &block)
    if localizable?(method)
      localize method
    else
      super method, *arguments, &block
    end
  end

  private

  #
  # Returns the translated content for the given attribute or the default if not found
  #
  def localize(attr)
    self.attributes[attr.to_s + '_' + normalize_locale(I18n.locale)] || self.attributes[attr.to_s + '_' + normalize_locale(I18n.default_locale)]
  end

  #
  # Does the method match a localizable attribute or the default
  #
  def localizable?(attr)
    self.attributes.has_key?(attr.to_s + '_' + normalize_locale(I18n.locale)) || self.attributes.has_key?(attr.to_s + '_' + normalize_locale(I18n.default_locale))
  rescue NoMethodError
    return false
  end

  def not_using_foreign_or_shop_link?
    foreign_link.blank? && link_to_shop.blank?
  end

  def slug_link
    ensure_slash_prefix normalize(self.send(("title_"+I18n.default_locale.to_s).to_sym))
  end
  
  def ensure_slash_prefix(str)
    str.index('/') == 0 ? str : '/' + str
  end

  private

  #
  # Sanitizes and dasherizes string to make it safe for URL's.
  #
  # Example:
  #
  #   slug.normalize('This... is an example!') # => "this-is-an-example"
  #
  # Note that the Unicode handling in ActiveSupport may fail to process some
  # characters from Polish, Icelandic and other languages.
  #
  def normalize(slug_text)
    return '' if slug_text.nil? || slug_text == ''
    ActiveSupport::Multibyte.proxy_class.new(strip_diacritics(slug_text.to_s)).normalize(:kc).
      gsub(/[\W]/u, ' ').
      strip.
      gsub(/\s+/u, '-').
      gsub(/-\z/u, '').
      downcase.
      to_s
  end

  #
  # Slug generation ascii approximations
  #
  ASCII_APPROXIMATIONS = {
    198 => "AE",
    208 => "D",
    216 => "O",
    222 => "Th",
    223 => "ss",
    230 => "ae",
    240 => "d",
    248 => "o",
    254 => "th",
    8217 => "", # apostrophe Õ
    187 => "",  # guillemets È
    171 => ""   # guillemets Ç
  }.freeze

  #
  # Remove diacritics (accents, umlauts, etc.) from the string. Borrowed
  # from "The Ruby Way."
  #
  def strip_diacritics(string)
    a = ActiveSupport::Multibyte.proxy_class.new(string || "").normalize(:kd)
    a.unpack('U*').inject([]) { |a, u|
      if ASCII_APPROXIMATIONS[u]
        a += ASCII_APPROXIMATIONS[u].unpack('U*')
      elsif (u < 0x300 || u > 0x036F)
        a << u
      end
      a
    }.pack('U*')
  end

end