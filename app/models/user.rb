class User < ActiveRecord::Base
  has_secure_password validations: false
  before_create :generate_token
  
  has_many :reviews
  has_many :queue_items, -> { order("position") }
  has_many :relationships
  has_many :followers, through: :relationships
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :full_name, presence: true
  
  def normalize_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index + 1)
    end
  end
  
  def follows?(another_user)
    following_relationships.map(&:user).include?(another_user)
  end
  
  def to_param
    token
  end
  
  private
  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
  
end