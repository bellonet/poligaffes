class AddAttachmentPhotoToRawPosts < ActiveRecord::Migration
  def self.up
    change_table :raw_posts do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :raw_posts, :photo
  end
end
