require 'rails_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end

    it_behaves_like 'requires admin' do
      let(:action) { get :new }
    end

    it 'sets @video variable if user is admin' do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_new_record
      expect(assigns(:video)).to be_instance_of(Video)
    end
  end

  describe 'POST create' do
    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end

    it_behaves_like 'requires admin' do
      let(:action) { post :create }
    end

    context 'with valid input' do
      before do
        set_current_admin
        post :create, video: {title: 'Titanic', category_id: 3, description: 'Romantic Story'}
      end

      it 'creates a video' do
        expect(Video.count).to eq(1)
      end

      it 'redirects to add video page' do
        expect(response).to redirect_to new_admin_video_path
      end

      it 'sets flash success message' do
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid input' do
      before do
        set_current_admin
        post :create, video: {title: 'Titanic'}
      end

      it 'does not create a video' do
        expect(Video.count).to eq(0)
      end

      it 'renders new template' do
        expect(response).to render_template :new
      end

      it 'sets @video variable' do
        expect(assigns(:video)).to be_instance_of(Video)
      end
    end
  end
end