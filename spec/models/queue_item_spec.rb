require "rails_helper"

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  
  describe "#video_title" do
    it "returns the title of the video associated with the queue item" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq(video.title)
    end
  end
  
  describe "#rating" do
    it "returns the rating from the review by the user on the associated video if there is one" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: user, video: video, rating: 1)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(1)
    end
    
    it "returns nil if the user hasn't reviewed associated video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end
  
  describe "#category_name" do
    it "returns the category of the video" do
      category = Fabricate(:category, name: "Drama")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("Drama")
    end
  end
  
  describe "#category" do
    it "returns the category of the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
end