class AddAttachmentPhotoToSocialMediaAccounts < ActiveRecord::Migration
  def self.up
    change_table :social_media_accounts do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :social_media_accounts, :photo
  end
end
