class RawPost < ActiveRecord::Base
  belongs_to :social_media_account
  has_one :yair, through: :social_media_account

  has_many :posts

  validates :social_media_account, presence: true
  validates :post, presence: true
  validates_uniqueness_of :id_in_site

  has_attached_file :video, :styles => {
    :thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10 }
  }, :processors => [:transcoder], :default_url => "/images/:style/missing.png"

  validates_attachment_content_type :video, :content_type => ['video/mp4']

  has_attached_file :photo, :styles => { :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
end

