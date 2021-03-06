class PasswordResetController < ApplicationController
  def enter_email
  end
  
  def confirm_password_reset
    user = User.find_by(email_address: params[:email])
    if user
      user.generate_new_token
      user.save
      AppMailer.password_reset(user).deliver
    else
      flash[:error] = params[:email].nil? ? 'Please enter a user email.' : 'This email was not found in the database.'
      redirect_to forgot_password_path
    end
  end
  
  def enter_new_password
    @user = User.find_by(token: params[:token])
    redirect_to invalid_token_path unless @user
  end
  
  def reset_password
    @user = User.find_by(token: params[:token])
    if @user
      @user.password = params[:new_password]
      @user.save
      @user.remove_token!
      redirect_to login_path
    else
      redirect_to invalid_token_path
    end
  end
end