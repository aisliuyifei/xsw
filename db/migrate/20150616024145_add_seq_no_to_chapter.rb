class AddSeqNoToChapter < ActiveRecord::Migration
  def change
    add_column :chapters,:seq,:integer
    add_index :chapters,[:book_id,:seq]
  end
end
   Book.all.each do |book|
    break if book.id>10
i =0
book.chapters.each do |c|
i+=1
c.seq=i
c.save
 end
end
