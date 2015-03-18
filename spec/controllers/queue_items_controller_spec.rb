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
end