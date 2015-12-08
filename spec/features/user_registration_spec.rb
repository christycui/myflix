require 'rails_helper'

feature 'user registers and gets charged', {js: true, vcr: true} do
  background do
    visit register_path
  end

  scenario 'with valid user info and valid card' do
    fill_in_valid_user_info
    make_payment('4242424242424242')
    expect(page).to have_content('Account created.')
  end

  scenario 'with valid user info and invalid card' do
    fill_in_valid_user_info
    make_payment '4000000000000127'
    expect(page).to have_content("Your card's security code is incorrect.")
  end

  scenario 'with valid user info and declined card' do
    fill_in_valid_user_info
    make_payment '4000000000000002'
    expect(page).to have_content('Your card was declined.')
  end

  scenario 'with invalid user info and valid card' do
    fill_in_invalid_user_info
    make_payment('4242424242424242')
    expect(page).to have_content('Please check input fields.')
  end

  scenario 'with invalid user info and invalid card' do
    fill_in_invalid_user_info
    make_payment('4000000000000127')
    expect(page).to have_content('Please check input fields.')
  end

  scenario 'with invalid user info and declined card' do
    fill_in_invalid_user_info
    make_payment('4000000000000002')
    expect(page).to have_content('Please check input fields.')
  end
end

def fill_in_valid_user_info
  fill_in "Email address", with: 'example@example.com'
  fill_in "Password", with: 'password'
  fill_in "Full name", with: 'Example'
end

def fill_in_invalid_user_info
  fill_in "Email address", with: 'example@example.com'
  fill_in "Password", with: 'password'
end

def make_payment(credit_card_number)
  fill_in "credit_card_number", with: credit_card_number
  fill_in "security_code", with: '123'
  select "10 - October", from: 'date_month'
  select "2017", from: 'date_year'
  click_button 'Sign Up'
end