require 'rails_helper'

feature 'admin sees paymnets' do
  background do
    user = Fabricate(:user, email_address: 'user@example.com')
    Fabricate(:payment, user: user, amount: 999)
  end

  scenario 'admin sees payments' do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content('user@example.com')
    expect(page).to have_content('$9.99')
  end

  scenario 'user can not see payments' do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).not_to have_content('user@example.com')
    expect(page).not_to have_content('$9.99')
    expect(page).to have_content("You don't have access to that.")
  end
end