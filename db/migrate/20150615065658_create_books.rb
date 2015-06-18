class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.integer :category_id
      t.string :author_name
      t.string :name
      t.string :original_url
      t.boolean :current_status
      t.text :description
      t.string :icon_url
      t.timestamps null: false
    
      
    end
    add_index :books, :name
    add_index :books, :author_name     
    add_index :books, :category_id
  end
end
