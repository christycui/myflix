require 'rails_helper'

describe UserSignup do
  describe "#sign_up" do
    context "when there is a token" do
      let(:inviter) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, user: inviter) }
      let(:customer) { double('charge', successful?: true) }

      before do
        allow(StripeWrapper::Customer).to receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user, full_name: 'Alice')).sign_up('123', invitation.token)
      end

      it 'makes new user follows inviter' do
        expect(inviter.reload.followers.last.full_name).to eq('Alice')
      end

      it 'makes inviter follows new user' do
        alice = User.find_by(full_name: 'Alice')
        expect(alice.followers.last).to eq(inviter)
      end

      it "expires the invitation token" do
        expect(invitation.reload.token).to be_nil
      end
    end

    context "when perfonal info and card is valid" do
      let(:customer) { double('charge', successful?: true) }

      before do
        allow(StripeWrapper::Customer).to receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user, email_address: 'example@example.com', full_name: 'J')).sign_up('123', nil)
      end

      after { ActionMailer::Base.deliveries.clear }

      it "create a user" do
        expect(User.count).to eq(1)
      end

      it 'sends an email to new user' do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['example@example.com'])
      end
      
      it "sends email containing user's name" do
        expect(ActionMailer::Base.deliveries.last.body).to include('J')
      end
    end

    context "when personal info is valid but card is invalid" do
      it "does not create a user" do
        customer = double('charge', successful?: false, error_message: 'Your card was declined.')
        allow(StripeWrapper::Customer).to receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up('123', nil)
        expect(User.count).to eq(0)
      end
    end

    context "when personal info is invalid" do
      let(:customer) { double('charge', successful?: true) }

      before do
        allow(StripeWrapper::Customer).to receive(:create).and_return(customer)
      end
      
      after { ActionMailer::Base.deliveries.clear }
      
      it "does not create a user when input is invalid" do
        UserSignup.new(User.new(email_address: "christycui@example.com", full_name: "Christy Cui")).sign_up('1', nil)
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        UserSignup.new(User.new(email_address: "christycui@example.com", full_name: "Christy Cui")).sign_up('1', nil)
      end

      it 'does not send out an email with invalid input' do
        UserSignup.new(User.new(email_address: "christycui@example.com", full_name: "Christy Cui")).sign_up('1', nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end