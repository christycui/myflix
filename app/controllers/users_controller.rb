class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params.require(:user).permit(:email_address, :password, :full_name))
    if @user.save
      AppMailer.welcome_new_user(@user).deliver
      flash[:notice] = "Your account is created!"
      redirect_to login_path
    else
      render 'new'
    end
  end
  
  def show
    @user = User.find_by_token params[:id]
  end
  
end