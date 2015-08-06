class Invitation < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :friend_name, :email, :message
  validates_uniqueness_of :email
end