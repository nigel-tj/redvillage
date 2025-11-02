class PaymentsController < ApplicationController
  before_action :set_store
  before_action :set_order
  before_action :authenticate_user!
  
  def new
    @payment = @order.payments.find_or_initialize_by(order: @order)
    @payment.amount ||= @order.total_amount
    @payment.currency ||= @order.currency
    authorize @payment
    
    # Create or retrieve PaymentIntent
    begin
      if @payment.stripe_payment_intent_id.present?
        payment_intent = Stripe::PaymentIntent.retrieve(@payment.stripe_payment_intent_id)
      else
        payment_intent = Stripe::PaymentIntent.create({
          amount: (@order.total_amount * 100).to_i, # Convert to cents
          currency: @order.currency.downcase,
          metadata: {
            order_id: @order.id.to_s,
            store_id: @store.id.to_s,
            user_id: current_user.id.to_s
          },
          automatic_payment_methods: {
            enabled: true
          }
        })
        
        @payment.stripe_payment_intent_id = payment_intent.id
        @order.stripe_payment_intent_id = payment_intent.id
        @payment.save if @payment.persisted?
        @order.save
      end
      
      @client_secret = payment_intent.client_secret
    rescue Stripe::StripeError => e
      flash[:alert] = "Payment error: #{e.message}"
    end
  end
  
  def create
    # Payment is handled client-side by Stripe, this just creates the payment record
    @payment = @order.payments.find_or_initialize_by(order: @order)
    @payment.amount = @order.total_amount
    @payment.currency = @order.currency
    authorize @payment
    
    if @payment.stripe_payment_intent_id.present?
      @payment.save
      redirect_to store_order_payment_path(@store, @order, @payment)
    else
      redirect_to new_store_order_payment_path(@store, @order)
    end
  end
  
  def confirm
    @payment = @order.payments.find(params[:id])
    authorize @payment
    
    # Check payment status with Stripe
    if @payment.stripe_payment_intent_id.present?
      begin
        payment_intent = Stripe::PaymentIntent.retrieve(@payment.stripe_payment_intent_id)
        
        if payment_intent.status == 'succeeded'
          @payment.mark_as_paid!
          @payment.stripe_charge_id = payment_intent.latest_charge if payment_intent.respond_to?(:latest_charge)
          @payment.save
          
          flash[:success] = 'Payment successful! Your order is being processed.'
          redirect_to store_order_path(@store, @order)
        elsif payment_intent.status == 'requires_payment_method'
          flash[:alert] = 'Payment failed. Please try again.'
          redirect_to new_store_order_payment_path(@store, @order)
        else
          @payment_status = payment_intent.status
          # Will render confirm view to show status
        end
      rescue Stripe::StripeError => e
        flash[:alert] = "Error checking payment status: #{e.message}"
      end
    else
      flash[:alert] = 'Payment intent not found.'
      redirect_to new_store_order_payment_path(@store, @order)
    end
  end
  
  def show
    confirm
  end
  
  private
  
  def set_store
    @store = Store.friendly.find(params[:store_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Store not found."
    redirect_to stores_path
  end
  
  def set_order
    @order = @store.orders.find(params[:order_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Order not found."
    redirect_to store_orders_path(@store)
  end
  
  def payment_params
    params.require(:payment).permit(:payment_method)
  end
end

