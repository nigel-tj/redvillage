class FeaturesController < ApplicationController
  include RoleBasedAccess
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_curator_or_admin, only: [:new, :create, :update, :edit, :destroy]
  layout "admin", only: [:new, :create, :update, :admin_index]
  
  private
  
  def require_curator_or_admin
    unless current_user&.curator? || current_user&.admin? || current_user&.editor?
      flash[:alert] = "You need curator, editor, or admin access to perform this action."
      redirect_to root_path
    end
  end   
  
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
  
  private
  def feature_params
    params.require(:feature).permit(:link,:image,:intro,:heading)
  end

end
