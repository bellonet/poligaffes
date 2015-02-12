class Post < ActiveRecord::Base
  include Poligaffes::Cache::Clearer

  after_save :clear_stats_cache
  after_save :clear_homepage_cache

  has_one :yair, through: :social_media_account
  has_one :social_media_account, through: :raw_post

  belongs_to :raw_post

  validates :raw_post, presence: true

  scope :not_empty, -> { joins(:raw_post).where("(raw_posts.post->>'story') ISNULL OR NOT (raw_posts.post->>'story') SIMILAR TO ?", "%(אוהב|הגיב|אהב)%") }

  def should_have_photo?
  	self.raw_post.post["type"]=="photo"
  end

  def should_have_video?
  	self.raw_post.post["type"]=="video"
  end

  def describe
    "פורסם ב- #{I18n.l raw_post.timestamp}: \n
    #{body.truncate(100)}"
  end

  def facebook_share_title
    "להדם: #{yair.first_name} #{yair.last_name} #{status=='deleted' ? 'מחק/ה' : 'ערכ/ה'} סטטוס"
  end

  private
  def clear_stats_cache
    Rails.cache.delete_matched 'top-cache-key'
  end
end
