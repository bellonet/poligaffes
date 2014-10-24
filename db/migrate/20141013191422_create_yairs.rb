class CreateYairs < ActiveRecord::Migration
  def change
    create_table :yairs do |t|
      t.string :name
      t.string :party
      t.string :field

      t.timestamps
    end
  end
end
