class RawPost < ActiveRecord::Base
  belongs_to :social_media_account
  validates :post, presence: true
  validates_uniqueness_of :id_in_site
end
