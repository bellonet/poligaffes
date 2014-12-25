class Post < ActiveRecord::Base
  belongs_to :social_media_account
  has_one :yair, through: :social_media_account

  belongs_to :raw_post

  validates :social_media_account, presence: true
  validates :raw_post, presence: true
end
