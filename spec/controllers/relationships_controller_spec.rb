require 'rails_helper'

describe RelationshipsController do
  
  let(:current_user) { Fabricate(:user) }
  before { set_current_user(current_user) }
  
  describe 'GET index' do
    
    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
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