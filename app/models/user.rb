class User < ActiveRecord::Base
  include Tokenable

  has_secure_password validations: false
  
  has_many :reviews
  has_many :queue_items, -> { order("position") }
  has_many :relationships
  has_many :followers, through: :relationships
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :invitations
  
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

  def generate_new_token
    generate_token
  end
  
end