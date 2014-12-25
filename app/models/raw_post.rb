class RawPost < ActiveRecord::Base
  belongs_to :social_media_account
  has_one :yair, through: :social_media_account

  has_many :posts

  validates :social_media_account, presence: true
  validates :post, presence: true
  validates_uniqueness_of :id_in_site
end
