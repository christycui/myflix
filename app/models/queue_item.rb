class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  
  validates_numericality_of :position, {only_integer: true}
  
  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video
  
  def rating
    review = video.reviews.where(user: self.user).first
    review.rating if review
  end
  
  def category_name
    category.name
  end
  
end