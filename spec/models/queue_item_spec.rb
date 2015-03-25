require "rails_helper"

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should delegate_method(:title).to(:video).with_prefix(:video) }
  it { should delegate_method(:category_name).to(:category).as(:name) }
  it { should delegate_method(:category).to(:video) }
  it { should validate_numericality_of(:position).only_integer }
  
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
  
  describe "#rating=" do
    it "changes the rating of the review if review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 5
      expect(review.reload.rating).to eq(5)
    end
    
    it "clears the rating of the review if review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = nil
      expect(review.reload.rating).to be_nil
    end
    
    it "creates a review with a rating if review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 5
      expect(Review.count).to eq(1)
    end
  end

end