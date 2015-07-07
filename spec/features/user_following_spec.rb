require 'rails_helper'

feature 'User following' do
  scenario 'user follows another user' do
    user = Fabricate(:user)
    another_user = Fabricate(:user)
    video = Fabricate(:video)
    review = Fabricate(:review, video: video, user: another_user)
    
    sign_in(user)
    visit video_path(video)
    click_link another_user.full_name
    click_link 'Follow'
    expect(page).to have_css('button', text: 'Following')
    click_link 'People'
    expect(page).to have_link(another_user.full_name)
    
    unfollow(user, another_user)
    expect(page).not_to have_link(another_user.full_name)
  end
  
  def unfollow(user, another_user)
    relationship = Relationship.where(user: another_user, follower: user).first
    find("a[href='/relationships/#{relationship.id}']").click
  end
end