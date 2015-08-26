require 'rails_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end

    context 'if user is not admin' do
      before do
        set_current_user
        get :new
      end

      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end

      it 'sets error flash message' do
        expect(flash[:error]).to be_present
      end
    end

    it 'sets @video variable if user is admin' do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_new_record
      expect(assigns(:video)).to be_instance_of(Video)
    end
  end
end