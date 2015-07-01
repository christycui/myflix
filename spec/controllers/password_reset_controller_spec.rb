require 'rails_helper'

describe PasswordResetController do
  describe 'POST confirm_password_reset' do
    
    after { ActionMailer::Base.deliveries.clear }
    
    it 'sends an email to user if regiestered' do
      user = Fabricate(:user)
      post :confirm_password_reset, email: user.email_address
      expect(ActionMailer::Base.deliveries.last.to).to eq([user.email_address])
    end
    
    it 'does not send an email if user is not registered' do
      post :confirm_password_reset, email: 'example@example.com'
      expect(ActionMailer::Base.deliveries).to be_empty
    end
    
    it 'sends password reset email if user is registered' do
      user = Fabricate(:user)
      post :confirm_password_reset, email: user.email_address
      expect(ActionMailer::Base.deliveries.last.body).to include('reset your password')
    end
  end
  
  describe 'GET enter_new_password' do
    it 'sets @token variable' do
      user = Fabricate(:user)
      get :enter_new_password, id: user.token
      expect(assigns(:token)).to eq(user.token)
    end
  end
  
  describe 'POST reset_password' do
    it 'sets @user variable' do
      user = Fabricate(:user)
      post :reset_password, token: user.token
      expect(assigns(:user)).to eq(user)
    end
    
    it 'updates user password' do
      user = Fabricate(:user)
      post :reset_password, token: user.token, new_password: 'new_pw'
      expect(user.reload.password).to eq('new_pw')
    end
    
    it 'generates a new token for the user'
    
    it 'redirects to login_path' do
      user = Fabricate(:user)
      post :reset_password, token: user.token
      expect(response).to redirect_to login_path
    end
  end
end