class Post < ActiveRecord::Base
  belongs_to :social_media_account
  has_one :yair, through: :social_media_account
end
