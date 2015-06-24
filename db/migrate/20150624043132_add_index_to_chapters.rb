class AddIndexToChapters < ActiveRecord::Migration
  def change
    add_index :chapters, :book_id
    add_index :chapters, :seq
  end
end

