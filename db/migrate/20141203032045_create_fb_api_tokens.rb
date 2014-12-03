class CreateFbApiTokens < ActiveRecord::Migration
  def change
    create_table :fb_api_tokens do |t|
      t.text :token
      t.datetime :expires
      t.integer :application_id
      t.text :application_name
      t.integer :user_id
      t.text :user

      t.timestamps
    end
    add_index :fb_api_tokens, :expires
  end
end
