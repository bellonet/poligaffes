class SocialMediaAccount < ActiveRecord::Base
  belongs_to :yair
  has_many :posts, dependent: :destroy

  has_attached_file :photo, :styles => { :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
end