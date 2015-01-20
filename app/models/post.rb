class Post < ActiveRecord::Base

  has_one :yair, through: :social_media_account
  has_one :social_media_account, through: :raw_post

  belongs_to :raw_post

  validates :social_media_account, presence: true
  validates :raw_post, presence: true

end
