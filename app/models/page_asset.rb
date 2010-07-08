class PageAsset < ActiveRecord::Base

  belongs_to :page
  
  has_attached_file :attachment,
                    :styles => { :small => "50x50>" },
                    :url => "/assets/static_content/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/static_content/:id/:style/:basename.:extension"
end
