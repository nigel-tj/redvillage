class AdsController < ApplicationController
  include RoleBasedAccess
  
  before_action :authenticate_user!
  before_action :require_admin, only: [:index, :new, :create, :update, :edit, :destroy]
  before_action :set_ad, only: [:show, :edit, :update, :destroy, :click]
  layout "admin", only: [:index, :new, :create, :update, :edit]
  
  def index
    @ads = Ad.includes(:ad_spot).order(created_at: :desc)
    @ads = @ads.where(ad_spot_id: params[:ad_spot_id]) if params[:ad_spot_id].present?
    @ads = @ads.where(active: params[:active]) if params[:active].present?
  end
  
  def new
    @ad = Ad.new
    @ad_spots = AdSpot.active.order(:page, :position)
  end

  def edit
    @ad_spots = AdSpot.active.order(:page, :position)
  end
  
  def create
    @ad = Ad.new(ad_params)
    if @ad.save
      flash[:notice] = "Successfully created ad."
      redirect_to ads_path
    else
      @ad_spots = AdSpot.active.order(:page, :position)
      render :new
    end
  end

  def update
    if @ad.update(ad_params)
      flash[:notice] = "Successfully updated ad."
      redirect_to ads_path
    else
      @ad_spots = AdSpot.active.order(:page, :position)
      render :edit
    end
  end

  def destroy
    if @ad.destroy
      flash[:notice] = "Successfully deleted ad."
    else
      flash[:alert] = "Could not delete ad."
    end
    redirect_to ads_path
  end
  
  # Public endpoint to track clicks
  def click
    @ad.click!
    if @ad.url.present?
      redirect_to @ad.url, allow_other_host: true
    else
      redirect_to root_path
    end
  end

  private
  
  def require_admin
    unless current_user&.admin?
      flash[:alert] = "You need admin access to perform this action."
      redirect_to root_path
    end
  end
  
  def set_ad
    @ad = Ad.find(params[:id])
  end
  
  def ad_params
    params.require(:ad).permit(:title, :image, :image_data, :url, :ad_spot_id, :start_date, :end_date, :active, :advertiser_name, :advertiser_email, :notes)
  end
end

