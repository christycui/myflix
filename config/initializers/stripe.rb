Stripe.api_key = ENV['stripe_secret_key']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    customer = User.find_by customer_token: event.data.object.customer
    Payment.create(user: customer, amount: event.data.object.amount, reference_id: event.data.object.id)
  end

  events.subscribe 'charge.failed' do |event|
    customer = User.find_by customer_token: event.data.object.customer
    customer.deactivate!
    AppMailer.account_inactive(customer).deliver
  end
end