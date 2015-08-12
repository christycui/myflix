require 'rails_helper'

describe InvitationsController do
  describe 'GET new' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end

    it 'sets @invite variable' do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end
  end

  describe 'POST create' do

    let(:user) { Fabricate(:user) }
    before { set_current_user(user) }

    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end

    context 'with valid input' do

      before { post :create, invitation: Fabricate.attributes_for(:invitation) }

      it 'creates an invitation' do
        expect(Invitation.count).to eq(1)
      end

      it 'sends out an invite email' do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it 'redirects to invitations#new page' do
        expect(response).to redirect_to new_invitation_path
      end

      it 'sets success flash message' do
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid input' do

      before { post :create, invitation: Fabricate.attributes_for(:invitation, friend_name: '') }

      after { ActionMailer::Base.deliveries.clear }

      it 'does not create an invitation' do
        expect(Invitation.count).to eq(0)
      end

      it 'does not send an invite email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'renders invitation#new template' do
        expect(response).to render_template :new
      end

      it 'sets @invitation variable' do
        expect(assigns(:invitation)).to be_instance_of(Invitation)
      end

      it 'displays flash error' do
        expect(response).to be_present
      end
    end
  end
end