class MainBannersController < ApplicationController
  include RoleBasedAccess
  
  before_action :authenticate_user!
  before_action :require_designer_or_admin, only: [:new, :create, :update, :edit, :destroy, :index]
  layout "admin", only: [:new, :create, :update, :edit, :index]
  
  private
  
  def require_designer_or_admin
    unless current_user&.designer? || current_user&.admin? || current_user&.curator? || current_user&.editor?
      flash[:alert] = "You need designer, curator, editor, or admin access to perform this action."
      redirect_to root_path
    end
  end

  def index
    @banners = if params[:page].present?
      MainBanner.where(page: params[:page])
    else
      MainBanner.all
    end
  end
  
  def new
    @banner = MainBanner.new 
  end

  def edit
    @banner = MainBanner.find(params[:id])
  end
  
  def create
    @banner = MainBanner.new(main_banner_params)
    if @banner.save
      flash[:notice] = "Successfully created banner."
      redirect_to "/banners_index"
    else
      render :action => 'new'
    end
  end

  def destroy
    @banner = MainBanner.find(params[:id])
    @banner.destroy
    flash[:notice] = "Successfully deleted banner."
    redirect_to "/banners_index"
  end

  def update
    @banner = MainBanner.find(params[:id])
    if @banner.update(main_banner_params)
      flash[:notice] = "Successfully updated banner."
      redirect_to '/banners_index'
    else
      render :action => 'edit'
    end
  end

  def show
    @banner = MainBanner.find(params[:id])
  end

  private
  def main_banner_params
    params.require(:main_banner).permit(:name,:title,:image, :page, :ticket_promo)
  end

end
