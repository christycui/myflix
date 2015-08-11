class Invitation < ActiveRecord::Base
  include Tokenable
  belongs_to :user

  validates_presence_of :friend_name, :email, :message
  validates_uniqueness_of :email

  def to_param
    token
  end

end