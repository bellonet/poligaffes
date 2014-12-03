class CreateFbApiTokens < ActiveRecord::Migration
  def change
    create_table :fb_api_tokens do |t|
      t.text :token
      t.datetime :expires
      t.column :application_id, :bigint
      t.text :application_name
      t.column :user_id, :bigint
      t.text :user

      t.timestamps
    end
    add_index :fb_api_tokens, :expires
  end
end
