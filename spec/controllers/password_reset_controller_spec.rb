require 'rails_helper'

describe PasswordResetController do
  describe 'POST confirm_password_reset' do
    context 'with blank email' do
      it 'redirects to forgot password page' do
        post :confirm_password_reset
        expect(response).to redirect_to forgot_password_path
      end

      it 'shows an error message' do
        post :confirm_password_reset
        expect(flash[:error]).to eq('Please enter a user email.')
      end
    end

    context 'with existing user email' do
      let(:user) { Fabricate(:user) }
      before { post :confirm_password_reset, email: user.email_address }
      after { ActionMailer::Base.deliveries.clear }
      
      it 'sends an email to user' do
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email_address])
      end
      
      it 'sends password reset email' do
        expect(ActionMailer::Base.deliveries.last.body).to include('reset your password')
      end

      it 'generates token for user' do
        expect(user.reload.token).to be_present
      end
    end

    context 'with non-existing email' do
      it 'does not send an email' do
        post :confirm_password_reset, email: 'example@example.com'
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'redirects to forgot_password_path' do
        post :confirm_password_reset,  email: 'non-existing'
        expect(response).to redirect_to forgot_password_path
      end

      it 'shows an error message' do
        post :confirm_password_reset, email: 'example@example.com'
        expect(flash[:error]).to eq('This email was not found in the database.')
      end
    end
  end
  
  describe 'GET enter_new_password' do
    it 'sets @user variable if token exists' do
      user = Fabricate(:user)
      get :enter_new_password, token: user.token
      expect(assigns(:user)).to eq(user)
    end

    it 'redirects to invalid_token_path if token does not exist' do
      get :enter_new_password, token: 'abc'
      expect(response).to redirect_to invalid_token_path
    end
  end
  
  describe 'POST reset_password' do
    context 'with valid token' do
      it 'sets @user variable' do
        user = Fabricate(:user)
        post :reset_password, token: user.token
        expect(assigns(:user)).to eq(user)
      end
      
      it 'updates user password' do
        user = Fabricate(:user)
        post :confirm_password_reset, email: user.email_address
        post :reset_password, token: user.reload.token, new_password: 'new_pw'
        expect(user.reload.authenticate('new_pw')).to be_truthy
      end
      
      it 'expires token' do
        user = Fabricate(:user)
        post :reset_password, token: user.token, new_password: 'new_pw'
        expect(user.reload.token).to be_nil
      end
      
      it 'redirects to login_path' do
        user = Fabricate(:user)
        post :reset_password, token: user.token
        expect(response).to redirect_to login_path
      end
    end

    context 'with invalid token' do
      it 'redirects to invalid_token_path' do
        post :reset_password, token: 'abc'
        expect(response).to redirect_to invalid_token_path
      end
    end
  end
end