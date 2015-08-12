require 'rails_helper'

feature 'User resets password' do
  scenario 'user forgot password' do
    user = Fabricate(:user)

    visit login_path
    click_link 'Forgot password?'
    expect(page).to have_content('Forgot Password?')
    fill_in "email", with: user.email_address
    click_button 'Send Email'

    open_email(user.email_address)
    current_email.click_link('link')
    fill_in 'user[password]', with: 'new_pw'
    click_button 'Reset Password'
    fill_in("email_address", with: user.email_address)
    fill_in("password", with: 'new_pw')
    click_button('Sign In')
    expect(page).to have_content(user.full_name)
  end
end