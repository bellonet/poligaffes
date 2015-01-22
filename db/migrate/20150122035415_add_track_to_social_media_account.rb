class AddTrackToSocialMediaAccount < ActiveRecord::Migration
  def up
    add_column :social_media_accounts, :track, :boolean, index: true

    SocialMediaAccount.all.each { |a| a.update_attributes({track: true}) }
  end
  def down
    remove_column :social_media_accounts, :track
  end
end
