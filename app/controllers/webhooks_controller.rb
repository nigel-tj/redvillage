class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  
  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']
    
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      render json: { error: 'Invalid payload' }, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: 'Invalid signature' }, status: :bad_request
      return
    end
    
    # Handle the event
    case event.type
    when 'payment_intent.succeeded'
      payment_intent = event.data.object
      handle_payment_success(payment_intent)
    when 'payment_intent.payment_failed'
      payment_intent = event.data.object
      handle_payment_failure(payment_intent)
    end
    
    render json: { received: true }
  end
  
  private
  
  def handle_payment_success(payment_intent)
    payment = Payment.find_by(stripe_payment_intent_id: payment_intent.id)
    return unless payment
    
    payment.mark_as_paid!
    payment.stripe_charge_id = payment_intent.latest_charge
    payment.save
    
    order = payment.order
    order.processing!
    
    # Send notification email here if needed
  end
  
  def handle_payment_failure(payment_intent)
    payment = Payment.find_by(stripe_payment_intent_id: payment_intent.id)
    return unless payment
    
    payment.mark_as_failed!
    
    # Send notification email here if needed
  end
end

