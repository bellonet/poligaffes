class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :yair, index: true
      t.string :site
      t.string :status
      t.string :how_long
      t.text :body

      t.timestamps
    end
  end
end
