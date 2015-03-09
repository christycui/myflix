class UsersController < ApplicationController
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
  
end