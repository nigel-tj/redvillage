class CartsController < ApplicationController
  before_action :set_store
  before_action :set_cart
  before_action :authenticate_user!, only: [:checkout]
  
  def show
    @cart_items = @cart.cart_items.includes(:product)
  end
  
  def add_item
    product = @store.products.find(params[:product_id])
    quantity = params[:quantity].to_i || 1
    
    if @cart.add_product(product, quantity)
      flash[:notice] = "#{product.name} added to cart!"
    else
      flash[:alert] = "Unable to add product. Check availability."
    end
    redirect_back(fallback_location: store_product_path(@store, product))
  end
  
  def update_item
    product = @store.products.find(params[:product_id])
    quantity = params[:quantity].to_i
    
    if product.can_purchase?(quantity)
      @cart.update_quantity(product, quantity)
      flash[:notice] = "Cart updated!"
    else
      flash[:alert] = "Unable to update cart. Not enough stock available for #{product.name}."
    end
    redirect_to store_cart_path(@store)
  end
  
  def remove_item
    product = @store.products.find(params[:product_id])
    @cart.remove_product(product)
    flash[:notice] = "Item removed from cart"
    redirect_to store_cart_path(@store)
  end
  
  def clear
    @cart.cart_items.destroy_all
    flash[:notice] = "Cart cleared"
    redirect_to store_cart_path(@store)
  end
  
  def checkout
    if @cart.empty?
      flash[:alert] = "Your cart is empty"
      redirect_to store_cart_path(@store)
      return
    end
    
    @order = Order.new(store: @store, user: current_user)
    @cart.cart_items.each do |item|
      @order.order_items.build(
        product: item.product,
        quantity: item.quantity,
        unit_price: item.product.price
      )
    end
    @order.calculate_total
  end
  
  private
  
  def set_store
    @store = Store.friendly.find(params[:store_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Store not found."
    redirect_to stores_path
  end
  
  def set_cart
    @cart = Cart.find_or_create_for(
      current_user, 
      @store, 
      session.id
    )
  end
end

