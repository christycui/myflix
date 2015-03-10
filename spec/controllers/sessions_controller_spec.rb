require "rails_helper"

describe SessionsController do
  describe 'GET new' do
    it "renders new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end
    
    it "redirects to home page for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end
  
  describe "POST create" do
    context "when authentication passes" do
      before do
        user = Fabricate(:user)
        post :create, email_address: user.email_address, password: user.password
      end
      
      it "saves user id in session" do
        user = Fabricate(:user)
        post :create, email_address: user.email_address, password: user.password
        expect(session[:user_id]).to eq(user.id)
      end
      
      it "redirect to home page" do
        expect(response).to redirect_to home_path
      end
      
      it "sets signed in notice" do
        expect(flash[:notice]).not_to be_blank
      end
    end
    
    context "when authentication fails" do
      before do
        user = Fabricate(:user)
        post :create, email_address: user.email_address, password: "wrong_password"
      end
      
      it "does not save failed user id to session" do
        expect(session[:user_id]).to be_nil
      end
      
      it "redirect to login page" do
        expect(response).to redirect_to login_path
      end
      
      it "sets notice for login error" do
        expect(flash[:error]).not_to be_blank
      end
    end
  end
  
  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end
    
    it "sets session user id to be nil" do
      expect(session[:user_id]).to be_nil
    end
    
    it "redirect to root path" do
      expect(response).to redirect_to root_path
    end
    
    it "sets notice for logging out" do
      expect(flash[:notice]).not_to be_blank
    end
  end
end