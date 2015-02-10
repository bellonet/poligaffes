class Post < ActiveRecord::Base
  after_save :clear_stats_cache

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

  private
  def clear_stats_cache
    Rails.cache.delete_matched 'top-cache-key'
  end

end
