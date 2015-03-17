require "rails_helper"
describe ReviewsController do
  describe "POST create" do
    context "if user not logged in" do
      it "redirects to login page" do
        session[:user_id] = nil
        post :create, video_id: Fabricate(:video).id
        expect(response).to redirect_to login_path
      end
    end
    
    context "if user is logged in" do
      let(:video) { Fabricate(:video) }
      let(:current_user) { Fabricate(:user) }
      before do
        session[:user_id] = current_user.id
      end
      
      context "with valid input" do
        before do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review) 
        end
        
        it "creates a new review" do
          expect(Review.count).to eq(1)
        end
        
        it "creates a new review associated with current user" do
          expect(Review.first.user).to eq(current_user)
        end
        
        it "creates a new review associated with the video" do
          expect(Review.first.video).to eq(video)
        end
        it "redirects to video page" do
          expect(response).to redirect_to video
        end
      end
      
      context "with invalid input" do
        before { post :create, review: {rating: 4}, video_id: video.id }
        it "does not create a review" do
          expect(Review.count).to eq(0)
        end
        it "renders videos#show template if validation fails" do
          expect(response).to render_template "videos/show"
        end
        it "sets @video" do
          expect(assigns(:video)).to eq(video)
        end
        it "sets @reviews" do
          review = Fabricate(:review, video: video)
          expect(assigns(:reviews)).to match_array([review])
        end
      end
      
    end
  end
end