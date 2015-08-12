module Tokenable
  extend ActiveSupport::Concern

  included do
    def remove_token!
      self.update_column(:token, nil)
    end
  end

  private
  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end