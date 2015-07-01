class PasswordResetController < ApplicationController
  def enter_email
  end
  
  def confirm_password_reset
    user = User.find_by_email_address params[:email]
    if user
      AppMailer.password_reset(user).deliver
    else
      flash[:notice] = 'Email was not found. Please try an existing user email.'
      redirect_to forgot_password_path
    end
  end
  
  def enter_new_password
    @user = User.find_by_token params[:id]
  end
  
  def reset_password
    @user = User.find_by_token params[:token]
    @user.password = params[:new_password]
    redirect_to login_path
  end
end