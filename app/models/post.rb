class Post < ActiveRecord::Base

  has_one :yair, through: :social_media_account
  has_one :social_media_account, through: :raw_post

  belongs_to :raw_post

  validates :raw_post, presence: true

  def should_have_photo?
  	self.raw_post.post["type"]=="photo"
  end

  def should_have_video?
  	self.raw_post.post["type"]=="video"
  end

end
