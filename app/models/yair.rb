class Yair < ActiveRecord::Base
	has_many :comments, dependent: :destroy
	validates :name, presence: true,
                    length: { minimum: 3 }
end
