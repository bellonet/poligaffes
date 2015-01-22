class SocialMediaAccount < ActiveRecord::Base
  belongs_to :yair
  has_many :posts, dependent: :destroy
  has_many :raw_posts, dependent: :destroy
  has_many :posts, through: :raw_posts

 	validates :name, presence: true, length: { minimum: 3 }
 	validates :site, presence: true, length: { minimum: 3 }

  has_attached_file :photo, :styles => { :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  scope :tracking,     -> { where(track: true) }
  scope :non_tracking, -> { where("track IS NULL or track = ?",false) }
end
