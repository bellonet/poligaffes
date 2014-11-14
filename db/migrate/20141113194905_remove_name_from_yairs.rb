class RemoveNameFromYairs < ActiveRecord::Migration
  def change
    remove_column :yairs, :name, :string
  end
end
