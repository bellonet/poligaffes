class AddFirstNameToYairs < ActiveRecord::Migration
  def change
    add_column :yairs, :first_name, :string
  end
end
