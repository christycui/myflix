require 'rails_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    before { StripeWrapper.set_api_key }
    describe '.create' do
      context 'valid card' do
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
          expect(response.amount).to eq(100)
        end
      end
    end
  end
end