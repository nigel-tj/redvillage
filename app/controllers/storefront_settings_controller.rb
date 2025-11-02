class StorefrontSettingsController < ApplicationController
  before_action :set_store
  before_action :set_storefront_settings
  before_action :authenticate_user!
  before_action :ensure_store_owner
  
  def show
    authorize @storefront_settings
  end
  
  def edit
    authorize @storefront_settings
  end
  
  def update
    authorize @storefront_settings
    
    if @storefront_settings.update(storefront_settings_params)
      flash[:notice] = "Storefront settings updated successfully!"
      redirect_to store_storefront_settings_path(@store)
    else
      flash.now[:alert] = "There was a problem updating storefront settings."
      render :edit, status: :unprocessable_entity
    end
  end
  
  def preview
    authorize @storefront_settings
    # Preview with current settings
    @preview_mode = true
    render 'stores/show', layout: 'application'
  end
  
  private
  
  def set_store
    @store = Store.friendly.find(params[:store_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Store not found."
    redirect_to stores_path
  end
  
  def set_storefront_settings
    @storefront_settings = @store.storefront_settings || @store.build_storefront_settings
  end
  
  def ensure_store_owner
    unless @store.owner?(current_user) || current_user.admin?
      flash[:alert] = "You don't have permission to edit this store."
      redirect_to @store
    end
  end
  
  def storefront_settings_params
    params.require(:storefront_settings).permit(:primary_color, :secondary_color, 
                                                :accent_color, :logo, :banner_image,
                                                :custom_css, :font_family, :theme)
  end
end

