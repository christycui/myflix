require 'rails_helper'

feature 'User following' do
  scenario 'user follows another user' do
    user = Fabricate(:user)
    another_user = Fabricate(:another_user)
    video = Fabricate(:video)
    review = Fabricate(:review, video: video, user: another_user)
    
    sign_in(user)
    visit video_path(video)
    click_link another_user.name
  end
  
  scenario 'user unfollows anther user'
end