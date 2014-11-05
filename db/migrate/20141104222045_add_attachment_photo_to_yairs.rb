class AddAttachmentPhotoToYairs < ActiveRecord::Migration
  def self.up
    change_table :yairs do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :yairs, :photo
  end
end
