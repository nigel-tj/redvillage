class AdSpotsController < ApplicationController
  include RoleBasedAccess
  
  before_action :authenticate_user!
  before_action :require_admin, only: [:index, :new, :create, :update, :edit, :destroy]
  layout "admin", only: [:index, :new, :create, :update, :edit]
  
  def index
    @ad_spots = AdSpot.order(:page, :position)
    @ad_spots = @ad_spots.where(page: params[:page]) if params[:page].present?
  end
  
  def new
    @ad_spot = AdSpot.new
  end

  def edit
    @ad_spot = AdSpot.find(params[:id])
  end
  
  def create
    @ad_spot = AdSpot.new(ad_spot_params)
    if @ad_spot.save
      flash[:notice] = "Successfully created ad spot."
      redirect_to ad_spots_path
    else
      render :new
    end
  end

  def update
    @ad_spot = AdSpot.find(params[:id])
    if @ad_spot.update(ad_spot_params)
      flash[:notice] = "Successfully updated ad spot."
      redirect_to ad_spots_path
    else
      render :edit
    end
  end

  def destroy
    @ad_spot = AdSpot.find(params[:id])
    if @ad_spot.ads.any?
      flash[:alert] = "Cannot delete ad spot with existing ads. Please remove or reassign ads first."
    elsif @ad_spot.destroy
      flash[:notice] = "Successfully deleted ad spot."
    else
      flash[:alert] = "Could not delete ad spot."
    end
    redirect_to ad_spots_path
  end

  private
  
  def require_admin
    unless current_user&.admin?
      flash[:alert] = "You need admin access to perform this action."
      redirect_to root_path
    end
  end
  
  def ad_spot_params
    params.require(:ad_spot).permit(:name, :page, :position, :width, :height, :price, :currency, :active, :description)
  end
end

