class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  def new
    @user = User.new
    if params.has_key?(:token) && params[:token] == nil
      redirect_to invalid_token_path
    elsif params[:token]
      @invitation = Invitation.find_by(token: params[:token])
      @user.email_address = @invitation.email
    end
  end
  
  def create
    @user = User.new(user_params)
    signup_result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:token])
    if signup_result.successful?
      flash[:success] = "Account created. Please log in with your credentials."
      redirect_to login_path
    else
      flash.now[:error] = signup_result.error_message
      render 'new'
    end
  end
  
  def show
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
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