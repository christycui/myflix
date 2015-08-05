class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      AppMailer.welcome_new_user(@user).deliver
      flash[:notice] = "Your account is created!"
      redirect_to login_path
    else
      render 'new'
    end
  end
  
  def show
    @user = User.find_by(token: params[:id])
  end

  def update
    @user = User.find_by(token: params[:id])
    if @user.update(user_params)
      flash[:notice] = "Your account is updated."
    else
      flash[:error] = "Something went wrong. Unsuccessful update."
    end
    redirect_to login_path
  end

  private
  def user_params
    params.require(:user).permit(:email_address, :password, :full_name)
  end
  
end