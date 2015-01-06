class Admin::FacebookApplication < ActiveRecord::Base
  has_many :fb_api_tokens
end
