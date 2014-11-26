class Yair < ActiveRecord::Base
	has_many :social_media_accounts, dependent: :destroy
	has_many :posts, through: :social_media_accounts, dependent: :destroy

	validates :last_name, presence: true,
                    length: { minimum: 2 }

    HUMAN_ATTRIBUTE_NAMES = {
	    first_name: 'שם פרטי',
	    last_name: 'שם משפחה',
	    party: 'מפלגה',
	    field: 'תחום'
  	}

  	class << self
    	def human_attribute_name attribute_name
      	HUMAN_ATTRIBUTE_NAMES[attribute_name.to_sym] || super
    	end
  	end

end
