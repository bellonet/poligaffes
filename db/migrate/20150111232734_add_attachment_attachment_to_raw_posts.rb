class AddAttachmentAttachmentToRawPosts < ActiveRecord::Migration
  def self.up
    change_table :raw_posts do |t|
      t.attachment :attachment
    end
  end

  def self.down
    remove_attachment :raw_posts, :attachment
  end
end
