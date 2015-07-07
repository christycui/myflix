require 'rails_helper'

feature 'User reset password' do
  scenario 'user forgot password' do
    user = Fabricate(:user)

    visit login_path
    click_link 'Forgot password?'
    expect(page).to have_content('Forgot Password?')
    fill_in "email", with: user.email_address
    click_button 'Send Email'
    expect(ActionMailer::Base.deliveries.last.to).to eq([user.email_address])
    visit "/password_reset/#{user.token}"
    fill_in 'user[password]', with: 'new_pw'
    sign_in(user)
    expect(page).to have_content(user.full_name)
  end
end