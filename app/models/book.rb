class Book < ActiveRecord::Base
  has_many :chapters
  belongs_to :cat
  
  
  def self.keyword_search(q)
    q = q.to_s
    if q
      @books = Book.where("books.name like :key or books.author_name like :key",key:"%#{q}%")
    end
    @books.uniq.order('updated_at desc')
  end
end
