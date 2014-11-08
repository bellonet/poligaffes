class RemoveYairFromPost < ActiveRecord::Migration
  def change
    remove_reference :posts, :yair, index: true
  end
end
