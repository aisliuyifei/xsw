class Book < ActiveRecord::Base
  has_many :chapters
  belongs_to :cat
end
