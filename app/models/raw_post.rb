class RawPost < ActiveRecord::Base
  belongs_to :social_media_account
  has_one :yair, through: :social_media_account

  has_many :posts

  validates :social_media_account, presence: true
  validates :post, presence: true
  validates_uniqueness_of :id_in_site

  has_attached_file :attachment
  validates_attachment_content_type :attachment,
    :content_type => ['video/mp4'],
    :if => :is_type_of_video?
  validates_attachment_content_type :attachment,
     :content_type => [/\Aimage\/.*\Z/],
     :if => :is_type_of_image?
  
  protected
  def is_type_of_video?
    attachment.content_type =~ %r(video)
  end

  def is_type_of_image?
    attachment.content_type =~ %r(image)
  end
