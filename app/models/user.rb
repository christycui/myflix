class User < ActiveRecord::Base
  has_secure_password validations: false
  
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :full_name, presence: true
end