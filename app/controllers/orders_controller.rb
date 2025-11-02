class OrdersController < ApplicationController
  before_action :set_store
  before_action :set_order, only: [:show, :update]
  before_action :authenticate_user!, except: [:show]
  
  def index
    @orders = policy_scope(Order).where(store: @store)
                                 .includes(:order_items, :products)
                                 .order(created_at: :desc)
                                 .page(params[:page]).per(20)
    
    @orders = @orders.by_user(current_user.id) unless current_user&.admin? || @store.owner?(current_user)
  end
  
  def show
    authorize @order
    @order_items = @order.order_items.includes(:product)
    @payment = @order.payment
  end
  
  def create
    @cart = Cart.find_or_create_for(current_user, @store, session.id)
    
    if @cart.empty?
      flash[:alert] = "Your cart is empty"
      redirect_to store_cart_path(@store)
      return
    end
    
    @order = Order.new(order_params)
    @order.store = @store
    @order.user = current_user
    @order.status = 'pending'
    
    # Build order items from cart
    @cart.cart_items.each do |item|
      unless item.product.can_purchase?(item.quantity)
        flash[:alert] = "#{item.product.name} is no longer available in the requested quantity"
        redirect_to store_cart_path(@store)
        return
      end
      
      @order.order_items.build(
        product: item.product,
        quantity: item.quantity,
        unit_price: item.product.price
      )
    end
    
    # Calculate total manually
    @order.total_amount = @order.order_items.sum { |item| item.quantity * item.product.price }
    authorize @order
    
    if @order.save
      # Clear cart
      @cart.cart_items.destroy_all
      
      # Redirect to payment
      redirect_to new_store_order_payment_path(@store, @order)
    else
      flash[:alert] = "There was a problem creating your order."
      render 'carts/checkout', status: :unprocessable_entity
    end
  end
  
  def update
    authorize @order
    
    if @order.update(order_params)
      flash[:notice] = "Order updated successfully!"
      redirect_to store_order_path(@store, @order)
    else
      flash[:alert] = "There was a problem updating the order."
      render :show, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_store
    @store = Store.friendly.find(params[:store_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Store not found."
    redirect_to stores_path
  end
  
  def set_order
    @order = @store.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Order not found."
    redirect_to store_orders_path(@store)
  end
  
  def order_params
    params.require(:order).permit(:shipping_address, :billing_address, 
                                  :shipping_name, :shipping_phone)
  end
end

