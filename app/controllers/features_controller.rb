class FeaturesController < ApplicationController
  include RoleBasedAccess
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_curator_or_admin, only: [:new, :create, :update, :edit, :destroy, :admin_index]
  layout "admin", only: [:new, :create, :update, :edit, :admin_index]
  layout "marketplace", only: [:index, :show]
  
  def index
    @features = Feature.order('created_at DESC')
  end

  def admin_index
    @features = Feature.order('created_at DESC')
    render :index
  end
  
  def new
    @feature = Feature.new
  end
  
  def create
    @feature = Feature.new(feature_params)
    if @feature.save
      flash[:notice] = "Successfully created feature."
      redirect_to '/admin_index'
    else
      render :new
    end
  end

  def show
    @feature = Feature.find(params[:id])
  end

  def edit
    @feature = Feature.find(params[:id])
  end
  
  def update
    @feature = Feature.find(params[:id])
    if @feature.update(feature_params)
      flash[:notice] = "Feature has been updated."
      redirect_to '/admin_index'
    else
      flash[:alert] = "Feature could not be updated."
      render :edit
    end
  end
  
  def destroy
    @feature = Feature.find(params[:id])
    if @feature.destroy
      flash[:notice] = "Feature has been deleted."
    else
      flash[:alert] = "Feature could not be deleted."
    end
    redirect_to '/admin_index'
  end
  
  private
  
  def feature_params
    params.require(:feature).permit(:link,:image,:intro,:heading)
  end

end
