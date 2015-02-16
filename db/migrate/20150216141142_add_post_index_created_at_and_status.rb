class AddPostIndexCreatedAtAndStatus < ActiveRecord::Migration
  def change
    add_index :posts, :created_at
    add_index :posts, :status
  end
end
