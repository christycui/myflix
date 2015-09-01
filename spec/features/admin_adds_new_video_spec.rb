require 'rails_helper'

feature 'admin adds a video' do
  scenario 'admin successfully adds a video' do
    sign_in(Fabricate(:admin))
    Fabricate(:category, name: 'Drama')
    visit new_admin_video_path

    fill_in 'Title', with: 'Titanic'
    select 'Drama', from: 'Category'
    fill_in 'Description', with: 'A good movie.'
    attach_file('Large cover', 'public/tmp/family_guy.jpg')
    attach_file('Small cover', 'public/tmp/futurama.jpg')
    fill_in 'Video URL', with: 'example.com'
    click_button 'Add Video'

    visit videos_path
    expect(page).should have_css('a img')
  end
end