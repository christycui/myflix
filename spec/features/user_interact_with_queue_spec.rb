require 'rails_helper'

feature 'User interacts with queue' do
  
  scenario "user adds videos to my queue and reorders the queue items" do
    user = Fabricate(:user)
    comedy = Fabricate(:category, name: 'Comedy')
    family_guy = Fabricate(:video, title: 'Family Guy', category: comedy)
    futurama = Fabricate(:video, title: "Futurama", category: comedy)
    monk = Fabricate(:video, title: "Monk", category: comedy)
    
    sign_in(user)
    add_video_to_queue(family_guy)
    expect_video_to_be_in_queue(family_guy)
    
    visit video_path(family_guy)
    expect_video_not_to_have_link("+ My Queue")
    
    add_video_to_queue(futurama)
    add_video_to_queue(monk)
    
    visit my_queue_path
    set_video_position(family_guy, 3)
    set_video_position(futurama, 1)
    set_video_position(monk, 2)
    
    update_queue
    
    expect_video_position(family_guy, 3)
    expect_video_position(futurama, 1)
    expect_video_position(monk, 2)
  end
  
  private
  def update_queue
    click_button("Update Instant Queue")
  end
  
  def expect_video_not_to_have_link(link_text)
    expect(page).not_to have_link(link_text)
  end
  
  def expect_video_to_be_in_queue(video)
    expect(page).to have_content('The video is added to your queue')
    expect(page).to have_content(video.title)
  end
  
  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link('+ My Queue')
  end

  def set_video_position(video, position)
    find("input[data-video-id='#{video.id}']").set(position)
  end
  
  def expect_video_position(video, position)
    expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)
  end
end