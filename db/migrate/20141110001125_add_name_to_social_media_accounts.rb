class AddNameToSocialMediaAccounts < ActiveRecord::Migration
  def change
    add_column :social_media_accounts, :name, :string
  end
end
