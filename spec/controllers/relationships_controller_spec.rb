require 'rails_helper'

describe RelationshipsController do
  
  let(:current_user) { Fabricate(:user) }
  before { set_current_user(current_user) }
  
  describe 'GET index' do
    
    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end
    
  end
  
  describe 'POST create' do
    
    let(:user1) { Fabricate(:user) }
    
    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end
    
    it 'creates the following relationship' do
      post :create, user_id: user1.id
      expect(Relationship.count).to eq(1)
    end
    
    it 'redirects to user#show' do
      post :create, user_id: user1.id
      expect(response).to redirect_to user_path(user1)
    end
    
    it 'does not create a relationship if current user already follows user' do
      Fabricate(:relationship, user: user1, follower: current_user)
      post :create, user_id: user1.id
      expect(Relationship.count).to eq(1)
    end
    
    it 'does not create a relationship if current user tries to follow self' do
      post :create, user_id: current_user.id
      expect(Relationship.count).to eq(0)
    end
    
  end
  
  describe 'DELETE :destroy' do
    
    let(:user1) { Fabricate(:user) }
    
    it_behaves_like 'requires sign in' do
      let(:action) { delete :destroy, id: 2 }
    end
    
    it 'deletes the relationship if follower is current user' do
      relationship = Fabricate(:relationship, user: user1, follower: current_user)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end
    
    it 'redirects to relationships#index' do
      relationship = Fabricate(:relationship, user: user1, follower: current_user)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end
    
    it 'does not delete the relationship if follower is not current user' do
      relationship = Fabricate(:relationship, user: user1, follower: Fabricate(:user))
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end
    
  end
  
end