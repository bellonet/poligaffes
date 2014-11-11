class RawPost < ActiveRecord::Base
  # validates :yair, presence: true
  validates :site_id, presence: true
  validates :site_user_id, presence: true
  validates :post, presence: true
end
