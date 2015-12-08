class UserSignup
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripeToken, invitation_token)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
      :amount => 999,
      :source => stripeToken,
      :description => "Monthly Subscription for @{@user.email_address}"
    )
      if charge.successful?
        @user.save
        handle_invitation(invitation_token)
        AppMailer.welcome_new_user(@user).deliver
        @status = :success
      else
        @status = :fail
        @error_message = charge.error_message
      end
    else
      @status = :fail
      @error_message = "Please check input fields."
    end
    self
  end

  def charge
    charge = StripeWrapper::Charge.create(
      :amount => 999,
      :source => stripeToken,
      :description => "Monthly Subscription for @{@user.email_address}"
    )
    charge.successful?
  end

  def successful?
    @status == :success
  end

  private
  def handle_invitation(invitation_token)
    if invitation_token
      invitation = Invitation.find_by(token: invitation_token)
      inviter = invitation.user
      Relationship.create(user: @user, follower: inviter)
      Relationship.create(user: inviter, follower: @user)
      invitation.update_column(:token, nil)
    end
  end
end