class AddLastNameToYairs < ActiveRecord::Migration
  def change
    add_column :yairs, :last_name, :string
  end
end
