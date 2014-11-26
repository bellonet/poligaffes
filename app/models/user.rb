class User < ActiveRecord::Base
	has_secure_password

	validates_uniqueness_of :email

	HUMAN_ATTRIBUTE_NAMES = {
		email: 'אימייל',
		password: 'סיסמא',
		password_confirmation: 'סיסמא'
  	}

  	class << self
    	def human_attribute_name attribute_name
      	HUMAN_ATTRIBUTE_NAMES[attribute_name.to_sym] || super
    	end
  	end
end
