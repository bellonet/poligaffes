class CreateRawPosts < ActiveRecord::Migration
  def change
    create_table :raw_posts do |t|
      t.json :post
      t.datetime :timestamp
      t.text :site_id
      t.text :site_user_id

      t.references :yair

      t.timestamps
    end

    add_index :raw_posts, :timestamp
    add_index :raw_posts, :site_id
    add_index :raw_posts, :site_user_id
    add_index :raw_posts, :yair_id
  end
end
