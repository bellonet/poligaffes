class CreateAdminFacebookApplications < ActiveRecord::Migration
  def change
    create_table :admin_facebook_applications do |t|
      t.string :app_id
      t.string :app_secret
      t.string :name

      t.timestamps
    end
  end
end
