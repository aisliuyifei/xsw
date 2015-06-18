class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.integer :book_id
      t.string :name
      t.text :content

      t.timestamps null: false
    end
  end
end
