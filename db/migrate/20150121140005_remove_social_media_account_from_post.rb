class RemoveSocialMediaAccountFromPost < ActiveRecord::Migration
  def up
  	remove_column :posts, :social_media_account_id
  end

  def down
  	change_table :posts do |t|
  		t.references :social_media_account
  	end
  end
end
