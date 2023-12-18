module Requests
  module StripeHelpers

    def generate_stripe_event_signature(payload)
      secret = ENV['STRIPE_WEBHOOK_SECRET']
      time = Time.now
      signature = Stripe::Webhook::Signature.compute_signature(time, payload, secret)
      Stripe::Webhook::Signature.generate_header(
        time,
        signature,
        scheme: Stripe::Webhook::Signature::EXPECTED_SCHEME
      )
    end

    def post_stripe_hook(payload, headers = {})
      headers = { 'Stripe-Signature': generate_stripe_event_signature(@payload.to_json) }.merge(headers)
      post '/stripe-webhooks', params: payload, headers: headers, as: :json
    end
  end
end
