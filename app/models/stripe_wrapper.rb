module StripeWrapper
  class Charge

    def self.create(options={})
      StripeWrapper.set_api_key
      response = Stripe::Charge.create(amount: options[:amount], currency: 'usd', source: options[:source], description: options[:description])
    end
  end

  def self.set_api_key
    Stripe.api_key = Rails.env.production? ? ENV['STRIPE_LIVE_SECRET_KEY'] : ENV['stripe_secret_key']
  end
end