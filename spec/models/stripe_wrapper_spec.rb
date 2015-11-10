require 'rails_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
          :number => "4242424242424242",
          :exp_month => 10,
          :exp_year => 2016,
          :cvc => "314"
        },
      ).id
  end

  let(:declined_card_token) do
    Stripe::Token.create(
      :card => {
          :number => "4000000000000002",
          :exp_month => 10,
          :exp_year => 2016,
          :cvc => "314"
        },
      ).id
  end

  describe StripeWrapper::Charge do
    describe '.create' do
      it 'charges the card successfully', :vcr do
        response = StripeWrapper::Charge.create(amount: 100, source: valid_token)
        expect(response.successful?).to be_truthy
      end

      it 'gets an invalid card', :vcr do
        response = StripeWrapper::Charge.create(amount: 100, source: declined_card_token)
        expect(response.successful?).to be_falsey
      end

      it 'returns the error message for declined charges', :vcr do
        response = StripeWrapper::Charge.create(amount: 100, source: declined_card_token)
        expect(response.error_message).to eq('Your card was declined.')
      end
    end
  end

  describe StripeWrapper::Customer do
    describe '.create' do
      it 'creates a customer with a valid card', :vcr do
        response = StripeWrapper::Customer.create(source: valid_token, email: 'example@example.com')
        expect(response).to be_successful
      end

      it 'does not create a customer with an invalid card', :vcr do
        response = StripeWrapper::Customer.create(source: declined_card_token, email: 'example@example.com')
        expect(response).not_to be_successful
      end

      it 'returns the error message for card failure', :vcr do
        response = StripeWrapper::Customer.create(source: declined_card_token, email: 'example@example.com')
        expect(response.error_message).to eq('Your card was declined.')
      end

      it 'returns the customer token for valid vard', :vcr do
        response = StripeWrapper::Customer.create(source: valid_token, email: 'example@example.com')
        expect(response.customer_token).to be_present
      end
    end
  end
end