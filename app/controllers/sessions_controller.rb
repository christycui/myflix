class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end
  
  def create
    user = User.find_by email_address: params[:email_address]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path, notice: "You're signed in. Enjoy!"
    else
      flash[:error] = "Invalid email or password."
      redirect_to login_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You've signed out."
  end
end