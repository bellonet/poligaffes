class AddSocialMediaAccountToPost < ActiveRecord::Migration
  def change
    add_reference :posts, :social_media_account, index: true
  end
end
