require 'rails_helper'

feature 'user invites friend' do
  scenario 'user successfully invites friend and friend registers account', {vcr: true, js: true} do
    user = Fabricate(:user)
    sign_in(user)

    invite_a_friend
    friend_accepts_invitation
    friend_signs_in
    friend_should_follow(user)
    inviter_should_follow(user)

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: 'Alice'
    fill_in "Friend's Email Address", with: 'alice@example.com'
    fill_in "Message", with: 'Please join MyFlix.'
    click_button 'Send Invitation'
    sign_out
  end

  def friend_accepts_invitation
    open_email 'alice@example.com'
    current_email.click_link('here')
    fill_in "Password", with: 'password'
    fill_in "user[full_name]", with: 'Alice'
    fill_in "credit_card_number", with: '4242424242424242'
    fill_in "security_code", with: '123'
    select "10 - October", from: 'date_month'
    select "2017", from: 'date_year'
    click_button 'Sign Up'
  end

  def friend_signs_in
    fill_in "email_address", with: 'alice@example.com'
    fill_in "Password", with: 'password'
    click_button 'Sign In'
  end

  def friend_should_follow(user)
    click_link 'People'
    expect(page).to have_content user.full_name
    sign_out
  end

  def inviter_should_follow(user)
    sign_in(user)
    click_link 'People'
    expect(page).to have_content 'Alice'
    sign_out
  end
end