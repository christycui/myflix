require 'rails_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it 'redirects to home page if user not admin' do
      get :new
      expect(response).to redirect_to root_path
    end

    it 'sets @video variable if user is admin' do
      user = Fabricate(:user, admin: true)
      set_current_user(user)
      get :new
      expect(assigns(:video)).to be_new_record
      expect(assigns(:video)).to be_instance_of(Video)
    end
  end
end