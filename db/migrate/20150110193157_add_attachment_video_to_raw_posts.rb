class AddAttachmentVideoToRawPosts < ActiveRecord::Migration
  def self.up
    change_table :raw_posts do |t|
      t.attachment :video
    end
  end

  def self.down
    remove_attachment :raw_posts, :video
  end
end
