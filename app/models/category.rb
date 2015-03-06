class Category < ActiveRecord::Base
  has_many :videos, -> {order "title"}
  
  def recent_videos
    Video.order("created_at DESC").limit(6)
  end
end