class FbApiToken < ActiveRecord::Base
  belongs_to :facebook_application, class: Admin::FacebookApplication
end
