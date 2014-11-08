class SocialMediaAccount < ActiveRecord::Base
  belongs_to :yair
  has_many :posts, dependent: :destroy
end
