class Post < ActiveRecord::Base
  include Poligaffes::Cache::Clearer

  after_save :clear_stats_cache
  after_save :clear_homepage_cache
  after_save :clear_post_page_cache
  after_save :clear_yair_page_cache

  has_one :yair, through: :social_media_account
  has_one :social_media_account, through: :raw_post

  belongs_to :raw_post

  validates :raw_post, presence: true

  scope :not_empty,      -> { joins(:raw_post).where("(raw_posts.post->>'story') ISNULL OR NOT (raw_posts.post->>'story') SIMILAR TO ? AND (raw_posts.post->>'story') = ?", "%(אוהב|הגיב|אהב|את תמונת הנושא|ה‏תמונה‏ שלו/שלה)%", '  ') }
  scope :edited,         -> { where(status: 'edited') }
  scope :deleted,        -> { where(status: 'deleted') }
  scope :last_edit_only, -> { where("not exists (select 1 from posts as ip where ip.raw_post_id=posts.raw_post_id and ip.status='edited' and ip.created_at > posts.created_at)") }

  def should_have_photo?
  	self.raw_post.post["type"]=="photo"
  end

  def should_have_video?
  	self.raw_post.post["type"]=="video"
  end

  def describe
    "פורסם ב- #{I18n.l raw_post.timestamp}: \n
    #{body ? body.truncate(100) : ''}"
  end

  def facebook_share_title
    "להדם: #{yair.first_name} #{yair.last_name} #{status=='deleted' ? 'מחק/ה' : 'ערכ/ה'} סטטוס"
  end

  # set per_page globally
  WillPaginate.per_page = 5

  private
  def clear_post_page_cache
    Rails.cache.delete_matched "posts/#{self.id}"
  end
end

