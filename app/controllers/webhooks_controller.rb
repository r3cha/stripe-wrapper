require 'json'
require 'stripe'

class WebhooksController < ApplicationController

  def index
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        request.body.read, request.env['HTTP_STRIPE_SIGNATURE'], ENV['STRIPE_WEBHOOK_SECRET']
      )
    rescue JSON::ParserError => e
      # Invalid payload
      render json: { error: { message: e.message }}, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render json: { error: { message: e.message, extra: "Sig verification failed" }}, status: :bad_request
      return 
    end

    case event.type
    when 'charge.succeeded'
      charge = event.data.object

      Charge.create(
        charge_id: charge.id,
        amount: charge.amount,
        currency: charge.currency
      )

    when 'charge.refunded'
      charge = event.data.object

      Charge.create(
        charge_id: charge.id,
        amount_refunded: charge.amount_refunded,
        currency: charge.currency
      )
    else
      puts "Unhandled event type: #{event.type}"
    end

    render json: { message: :success }
  end

end
