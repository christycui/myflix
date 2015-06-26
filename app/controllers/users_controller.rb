class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params.require(:user).permit(:email_address, :password, :full_name))
    if @user.save
      flash[:notice] = "Your account is created!"
      redirect_to login_path
    else
      render 'new'
    end
  end
  
  def show
    @user = User.find params[:id]
    @relationship = Relationship.where(user_id: @user, follower_id: current_user).first
  end
  
end