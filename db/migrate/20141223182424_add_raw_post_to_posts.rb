class AddRawPostToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :raw_post, index: true
  end
end
