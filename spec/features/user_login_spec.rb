require 'rails_helper'

feature "user logs in" do
  
  scenario "user logs in with correct credentials" do
    user = Fabricate(:user)
    sign_in(user)
    expect(page).to have_content(user.full_name)
  end
  
  scenario "user fails to log in because of incorrect credentials" do
    visit login_path
    fill_in "email_address", with: Faker::Internet.email
    fill_in "password", with: Faker::Lorem.word
    click_button("Sign In")
    expect(page).to have_content('Sign In')
    expect(page).to have_content('Invalid email or password')
  end
 
end