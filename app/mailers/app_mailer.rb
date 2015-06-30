class AppMailer < ActionMailer::Base
  def welcome_new_user(user)
    @user = user
    mail from: 'no-reply@myflix.com', to: user.email_address, subject: 'Welcome to MyFliX!'
  end
end