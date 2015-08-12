class InvitationsController < ApplicationController
  before_action :require_user, only: [:new, :create]
  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(params.require(:invitation).permit(:friend_name, :email, :message))
    @invitation.user = current_user
    if @invitation.save
      AppMailer.invitation(@invitation).deliver
      flash[:notice] = 'Your invitation was sent.'
      redirect_to new_invitation_path
    else
      flash.now[:error] = 'Your invitation was not sent. Please check input fields.'
      render 'new'
    end
  end
end