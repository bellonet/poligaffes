class CreateSocialMediaAccounts < ActiveRecord::Migration
  def change
    create_table :social_media_accounts do |t|
      t.references :yair, index: true
      t.string :site
      t.string :link

      t.timestamps
    end
  end
end
