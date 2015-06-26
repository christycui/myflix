require 'rails_helper'

describe RelationshipsController do
  
  let(:current_user) { Fabricate(:user) }
  before { set_current_user(current_user) }
  
  describe 'GET index' do
    
    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end
    
    it 'sets @following variable' do
      user1 = Fabricate(:user)
      relationship = Relationship.create(user_id: user1.id, follower_id: current_user.id)
      get :index
      expect(assigns(:following)).to match_array([relationship])
    end
    
  end
  
  describe 'DELETE :destroy' do
    
    it 'deletes the relationship' do
      user1 = Fabricate(:user)
      relationship = Relationship.create(user_id: user1.id, follower_id: current_user.id)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end
    
    it 'redirects to relationships#index' do
      user1 = Fabricate(:user)
      relationship = Relationship.create(user_id: user1.id, follower_id: current_user.id)
      delete :destroy, id: relationship
      expect(response).to redirect_to relationships_path
    end
    
  end
  
end