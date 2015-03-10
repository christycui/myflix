require 'rails_helper'
describe VideosController do
  describe "GET show" do
    it "sets the @video variable for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "redirect user to login page for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to login_path
    end
  end
  
  describe "GET search" do
    it "sets @results variable for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      family_guy = Fabricate(:video, title: "Family Guy")
      get :search, search_str: "family"
      expect(assigns(:results)). to eq([family_guy])
    end
      
    it "redirect user to login page for unauthenticated users" do
      family_guy = Fabricate(:video, title: "Family Guy")
      get :search, search_str: "family"
      expect(response).to redirect_to login_path
    end
  end
end