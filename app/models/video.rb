class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order("created_at DESC") }
  has_many :queue_items

  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :large_cover, LargeCoverUploader
  
  validates_presence_of :title, :description
  
  def self.search_by_title(str)
    return [] if str.blank?
    where("lower(title) LIKE ?", "%#{str.downcase}%").order("created_at DESC")
  end

  def rating
    reviews.average(:rating).round(1) if reviews.average(:rating)
  end
end