class User < ActiveRecord::Base
  has_secure_password validations: false
  
  has_many :reviews
  has_many :queue_items, -> { order("position") }
  has_many :relationships
  has_many :followers, through: :relationships
  
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :full_name, presence: true
  
  def normalize_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index + 1)
    end
  end
  
end