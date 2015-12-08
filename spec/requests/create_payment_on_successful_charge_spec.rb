require 'rails_helper'

describe 'create payment on successful charge' do
  let(:event_data) do
    {
      "id" => "evt_174Ed8AB0zIqu5n0rH89nSaa",
      "object" => "event",
      "api_version" => "2015-08-19",
      "created" => 1446833286,
      "data" => {
        "object" => {
          "id" => "ch_174Ed8AB0zIqu5n0X7qkbbRH",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => "txn_174Ed8AB0zIqu5n0eSgha1LN",
          "captured" => true,
          "created" => 1446833286,
          "currency" => "usd",
          "customer" => "cus_7IqJmx4lGusW65",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => nil,
          "failure_message" => nil,
          "fraud_details" => {},
          "invoice" => "in_174Ed8AB0zIqu5n0S1z47Bp1",
          "livemode" => false,
          "metadata" => {},
          "paid" => true,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_174Ed8AB0zIqu5n0X7qkbbRH/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_174Ed4AB0zIqu5n0nXdstOqM",
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
            "customer" => "cus_7IqJmx4lGusW65",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 11,
            "exp_year" => 2018,
            "fingerprint" => "lLe38KkKeTa3Vxqn",
            "funding" => "credit",
            "last4" => "4242",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "statement_descriptor" => nil,
          "status" => "succeeded"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_7IqJxODANilKYj",
      "type" => "charge.succeeded"
    }
  end
  it 'creates payment with webhook from stripe for succeeded charges', :vcr do
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end

  it 'creates payment related to the user', :vcr do
    user = Fabricate(:user, customer_token: 'cus_7IqJmx4lGusW65')
    post '/stripe_events', event_data
    expect(Payment.first.user).to eq(user)
  end

  it 'creates the payment with the correct amount', :vcr do
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(999)
  end

  it 'creates the payment with reference id', :vcr do
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq("ch_174Ed8AB0zIqu5n0X7qkbbRH")
  end
end