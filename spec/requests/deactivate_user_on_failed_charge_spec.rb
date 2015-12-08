require 'rails_helper'

describe 'deactivate user on failed charges' do
  let(:failed_event) do
    {
      "id" => "evt_174GFEAB0zIqu5n0C3MuvX8W",
      "object" => "event",
      "api_version" => "2015-08-19",
      "created" => 1446839492,
      "data" => {
        "object" => {
          "id" => "ch_174GFEAB0zIqu5n0dDssjgu3",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1446839492,
          "currency" => "usd",
          "customer" => "cus_7Ir7zDs69J3rGS",
          "description" => "",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {},
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {},
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_174GFEAB0zIqu5n0dDssjgu3/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_174GEmAB0zIqu5n0azTZ7dxJ",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_zip_check" => nil,
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_7Ir7zDs69J3rGS",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 11,
            "exp_year" => 2016,
            "fingerprint" => "1eKe0r7FFTtNvnr0",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "statement_descriptor" => nil,
          "status" => "failed"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_7IrzxlmQZnnkxd",
      "type" => "charge.failed"
    }
  end

  after { ActionMailer::Base.deliveries.clear }

  it 'deactivates the user for failed charges', :vcr do
    user = Fabricate(:user, customer_token: "cus_7Ir7zDs69J3rGS")
    post '/stripe_events', failed_event
    expect(user.reload).not_to be_active
  end

  it 'sends the user an email', :vcr do
    user = Fabricate(:user, customer_token: "cus_7Ir7zDs69J3rGS")
    post '/stripe_events', failed_event
    expect(ActionMailer::Base.deliveries.last.to).to eq([user.email_address])
  end
end