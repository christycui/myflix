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
    if @user.save
      AppMailer.welcome_new_user(@user).deliver
      flash[:notice] = "Your account is created!"
      handle_invitation
      Stripe.api_key = ENV['stripe_secret_key']
      charge = Stripe::Charge.create(
        :amount => 999, # amount in cents
        :currency => "usd",
        :source => params[:stripeToken],
        :description => "Monthly Subscription for @{@user.email_address}"
      )
      flash[:success] = "Payment successful. Please log in with your credentials."
      redirect_to login_path
    else
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

  def handle_invitation
    if params[:token]
      invitation = Invitation.find_by(token: params[:token])
      inviter = invitation.user
      Relationship.create(user: @user, follower: inviter)
      Relationship.create(user: inviter, follower: @user)
      invitation.update_column(:token, nil)
    end
  end
  
end