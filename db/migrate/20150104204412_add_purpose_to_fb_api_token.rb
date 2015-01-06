class AddPurposeToFbApiToken < ActiveRecord::Migration
  def change
    add_column :fb_api_tokens, :purpose, :string
    add_index :fb_api_tokens, :purpose
  end
end
