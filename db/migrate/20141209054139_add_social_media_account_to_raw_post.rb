class AddSocialMediaAccountToRawPost < ActiveRecord::Migration
  def up
    remove_column :raw_posts, :yair_id
    remove_column :raw_posts, :site_user_id
    remove_column :raw_posts, :site_id
    add_column :raw_posts, :id_in_site, :string
    add_reference :raw_posts, :social_media_account, index: true

    add_index :raw_posts, :id_in_site
  end

  def down
    add_reference :raw_posts, :yair, index: true
    add_column :raw_posts, :site_user_id, :text
    add_column :raw_posts, :site_id, :text
    remove_column :raw_posts, :id_in_site
    remove_column :raw_posts, :social_media_account_id
  end
end
