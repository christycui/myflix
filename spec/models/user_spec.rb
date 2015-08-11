require "rails_helper"

describe User do
  it { should validate_presence_of(:email_address).on(:create) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email_address) }
  it { should have_many(:reviews) }
  it { should have_many(:queue_items).order("position") }
  it { should have_many(:relationships) }
  it { should have_many(:followers).through(:relationships) }
  it { should have_many(:following_relationships).class_name('Relationship').with_foreign_key(:follower_id) }
  it { should have_many(:invitations) }

  it_behaves_like 'tokenable' do
    let(:object) { Fabricate(:user) }
  end
  
  describe '#follows?' do
    it 'returns true if user has a following relationship with another user' do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      Fabricate(:relationship, user: user1, follower: user2)
      expect(user2.follows?(user1)).to be_truthy
    end
    
    it 'returns false if user does not have a following relationship with another user' do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      expect(user2.follows?(user1)).to be_falsy
    end
  end
end
