class RemoveSiteFromPost < ActiveRecord::Migration
  def change
    remove_column :posts, :site, :string
  end
end
