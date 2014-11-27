class Yair < ActiveRecord::Base
	has_many :social_media_accounts, dependent: :destroy
	has_many :posts, through: :social_media_accounts, dependent: :destroy

	validates :last_name, presence: true,
                    length: { minimum: 2 }
end
