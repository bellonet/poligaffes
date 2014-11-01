class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :yair, index: true
      t.string :site
      t.string :status
      t.string :duration
      t.text :body

      t.timestamps
    end
  end
end
