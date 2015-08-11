class Invitation < ActiveRecord::Base
  belongs_to :user
  before_create :generate_token

  validates_presence_of :friend_name, :email, :message
  validates_uniqueness_of :email

  def to_param
    invitation_token
  end

  private
  def generate_token
    self.invitation_token = SecureRandom.urlsafe_base64
  end
end