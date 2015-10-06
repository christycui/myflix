module StripeWrapper
  class Charge
    attr_reader :response, :error_message
    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(amount: options[:amount], currency: 'usd', source: options[:source], description: options[:description])
        new(response: response, error_message: nil)
      rescue Stripe::CardError => e
        new(response: e, error_message: e.message)
      end
    end

    def successful?
      error_message.blank?
    end
  end
end