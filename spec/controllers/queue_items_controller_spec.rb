require "rails_helper"

describe QueueItemsController do
  describe "GET index" do
    it "redirects to login page if not logged in" do
      session[:user_id] = nil
      get :index
      expect(response).to redirect_to login_path
    end
    it "sets @queue_items for queue_items/index page if logged in" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item])
    end
  end
  
  describe "POST create" do
    it "redirects to login page if not logged in" do
      session[:user_id] = nil
      post :create
      expect(response).to redirect_to login_path
    end
    
    context "if user is logged in" do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      before { session[:user_id] = user.id }
      
      it "redirects to my queue page if the video is added to queue" do
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end
      
      it "creates a queue item" do
        post :create, video_id: video.id
        expect(QueueItem.count).to_not eq(0)
      end
      
      it "creates a queue item associated with the user" do
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(user)
      end
      
      it "creates a queue item associated with the video" do
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end
      
      it "adds the video to the end of the queue if not in queue" do
        video2 = Fabricate(:video)
        queue_item = Fabricate(:queue_item, user: user, video: video2)
        post :create, video_id: video.id
        expect(user.queue_items.map(&:video)).to match_array([video, video2])
      end
      
      it "sets video added notice if a queue item is created" do
        post :create, video_id: video.id
        expect(flash[:notice]).not_to be_blank
      end
      
      it "does not create a queue item if already in queue" do
        queue_item = Fabricate(:queue_item, user: user, video: video)
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
      
      it "sets already added error if already in queue" do
        queue_item = Fabricate(:queue_item, user: user, video: video)
        post :create, video_id: video.id
        expect(flash[:error]).not_to be_blank
      end
     
    end
  end
end