class Yair < ActiveRecord::Base
	has_many :social_media_accounts, dependent: :destroy
	has_many :posts, through: :social_media_accounts, dependent: :destroy

	validates :name, presence: true,
                    length: { minimum: 3 }

  has_attached_file :photo, :styles => { :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
end
