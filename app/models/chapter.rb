class Chapter < ActiveRecord::Base
  belongs_to :book
  validates_uniqueness_of :seq,:scope=>[:book_id]
  scope :reverse_order, -> { order('seq desc') }
  
end
