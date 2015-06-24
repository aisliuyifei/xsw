class AddSeqNoToChapter < ActiveRecord::Migration
  def change
    add_column :chapters,:seq,:integer
    add_index :chapters,[:book_id,:seq]
  end
end
