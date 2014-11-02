class AddTimestampToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :timestamp, :timestamp
  end
end
