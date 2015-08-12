require 'rails_helper'

describe Invitation do
  it { should belong_to(:user) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:friend_name) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:message) }

  it 'generates new token when invitation is created' do
    invitation = Fabricate(:invitation)
    expect(invitation.token).to be_present
  end
end