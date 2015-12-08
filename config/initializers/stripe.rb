Stripe.api_key = ENV['stripe_secret_key']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    customer = User.where(customer_token: event.data.object.customer).first
    Payment.create(user: customer, amount: event.data.object.amount, reference_id: event.data.object.id)
  end

  events.subscribe 'charge.failed' do |event|
    customer = User.where(customer_token: event.data.object.customer).first
    customer.deactivate!
    AppMailer.account_inactive(customer).deliver
  end
end