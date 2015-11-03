require 'rails_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe '.create' do
      it 'charges the card successfully', :vcr do
        token = Stripe::Token.create(
          :card => {
              :number => "4242424242424242",
              :exp_month => 10,
              :exp_year => 2016,
              :cvc => "314"
            },
          )
        response = StripeWrapper::Charge.create(amount: 100, source: token.id)
        expect(response.successful?).to be_truthy
      end

      it 'gets an invalid card', :vcr do
        token = Stripe::Token.create(
          :card => {
              :number => "4000000000000002",
              :exp_month => 10,
              :exp_year => 2016,
              :cvc => "314"
            },
          )
        response = StripeWrapper::Charge.create(amount: 100, source: token.id)
        expect(response.successful?).to be_falsey
      end

      it 'returns the error message for declined charges', :vcr do
        token = Stripe::Token.create(
          :card => {
              :number => "4000000000000002",
              :exp_month => 10,
              :exp_year => 2016,
              :cvc => "314"
            },
          )
        response = StripeWrapper::Charge.create(amount: 100, source: token.id)
        expect(response.error_message).to eq('Your card was declined.')
      end
    end
  end
end