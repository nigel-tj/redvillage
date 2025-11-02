class ProductsController < ApplicationController
  before_action :set_store
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @products = policy_scope(Product).where(store: @store)
                                     .includes(:product_images, :store)
                                     .page(params[:page]).per(12)
    
    # Filtering
    @products = @products.active if params[:status] == 'active'
    @products = @products.featured if params[:featured] == 'true'
    @products = @products.in_stock if params[:in_stock] == 'true'
    
    # Search
    if params[:search].present?
      @products = @products.where("name ILIKE ? OR description ILIKE ?", 
                                  "%#{params[:search]}%", "%#{params[:search]}%")
    end
  end

  def show
    authorize @product
    @related_products = @store.products.where.not(id: @product.id)
                              .active.limit(4)
  end

  def new
    @product = @store.products.build
    authorize @product
  end

  def create
    @product = @store.products.build(product_params)
    authorize @product
    
    if @product.save
      flash[:notice] = "Product created successfully!"
      redirect_to store_product_path(@store, @product)
    else
      flash.now[:alert] = "There was a problem creating the product."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @product
  end

  def update
    authorize @product
    
    if @product.update(product_params)
      flash[:notice] = "Product updated successfully!"
      redirect_to store_product_path(@store, @product)
    else
      flash.now[:alert] = "There was a problem updating the product."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @product
    
    if @product.destroy
      flash[:notice] = "Product deleted successfully!"
      redirect_to store_products_path(@store)
    else
      flash[:alert] = "There was a problem deleting the product."
      redirect_to store_product_path(@store, @product)
    end
  end

  private

  def set_store
    @store = Store.friendly.find(params[:store_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Store not found."
    redirect_to stores_path
  end

  def set_product
    @product = @store.products.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Product not found."
    redirect_to store_products_path(@store)
  end

  def product_params
    params.require(:product).permit(:name, :description, :sku, :price, 
                                    :compare_at_price, :inventory_quantity, 
                                    :weight, :status, :featured)
  end
end

