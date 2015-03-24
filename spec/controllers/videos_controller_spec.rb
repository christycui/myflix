require 'rails_helper'
describe VideosController do
  before { set_current_user }
  
  describe "GET show" do
    let(:video) { Fabricate(:video) }
    it "sets the @video variable for authenticated users" do
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
    
    it "sets the @reviews variable for authenticated users" do
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: video.id }
    end
  end
  
  describe "GET search" do
    it "sets @results variable for authenticated users" do
      family_guy = Fabricate(:video, title: "Family Guy")
      get :search, search_str: "family"
      expect(assigns(:results)).to eq([family_guy])
    end
      
    it_behaves_like "requires sign in" do
      let(:action) { get :search, search_str: "family" }
    end
  end
end