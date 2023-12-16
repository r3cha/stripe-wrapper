require 'stripe'

class StripeService
  def self.create_charge(amount, currency)
    Stripe::Charge.create(
      amount: amount,
      currency: currency,
      source: 'tok_visa',
      description: 'My First Test Charge (created for API docs)',
    )
  end

  def self.refund_charge(charge_id)
    Stripe::Refund.create(charge: charge_id)
  end
end