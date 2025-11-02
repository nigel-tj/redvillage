class ProductImagesController < ApplicationController
  before_action :set_store
  before_action :set_product
  before_action :set_product_image, only: [:destroy, :update_position]
  before_action :authenticate_user!
  before_action :ensure_store_owner
  
  def create
    @product_image = @product.product_images.build(product_image_params)
    @product_image.product = @product # Ensure association
    authorize @product_image
    
    # Set position if not provided
    @product_image.position ||= @product.product_images.maximum(:position).to_i + 1
    
    if @product_image.save
      flash[:notice] = "Image added successfully!"
    else
      flash[:alert] = "There was a problem adding the image."
    end
    
    redirect_to edit_store_product_path(@store, @product)
  end
  
  def destroy
    authorize @product_image
    @product_image.destroy
    flash[:notice] = "Image removed successfully!"
    redirect_to edit_store_product_path(@store, @product)
  end
  
  def update_position
    authorize @product_image
    @product_image.update(position: params[:position])
    head :ok
  end
  
  private
  
  def set_store
    @store = Store.friendly.find(params[:store_id])
  end
  
  def set_product
    @product = @store.products.friendly.find(params[:product_id])
  end
  
  def set_product_image
    @product_image = @product.product_images.find(params[:id])
  end
  
  def ensure_store_owner
    unless @store.owner?(current_user) || current_user.admin?
      flash[:alert] = "You don't have permission to perform this action."
      redirect_to @store
    end
  end
  
  def product_image_params
    params.require(:product_image).permit(:image, :alt_text, :position)
  end
end

