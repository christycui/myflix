class AppMailer < ActionMailer::Base
  def welcome_new_user(user)
    @user = user
    mail from: 'no-reply@myflix.com', to: user.email_address, subject: 'Welcome to MyFliX!'
  end
  
  def password_reset(user)
    @user = user
    mail from: 'no-reply@myflix.com', to: user.email_address, subject: 'Reset Password - MyFliX'
  end

  def invitation(invitation)
    @invitation = invitation
    mail from: 'no-reply@myflix.com', to: invitation.email, subject: 'MyFliX Invite'
  end

  def account_inactive(user)
    @user = user
    mail from: 'customer_service@myflix.com', to: user.email_address, subject: 'Your MyFliX Account Is Currently Inactive'
  end
end