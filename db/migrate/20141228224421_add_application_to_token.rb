class AddApplicationToToken < ActiveRecord::Migration
  def change
    add_reference :fb_api_tokens, :facebook_application
  end
end
