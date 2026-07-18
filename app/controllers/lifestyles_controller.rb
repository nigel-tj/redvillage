class LifestylesController < ApplicationController
  include RoleBasedAccess

  before_action :authenticate_user!, except: [:index]
  before_action :require_admin, only: [:new, :create, :update, :lifestyle_admin_index]
  layout "admin", only: [:new, :create, :update, :lifestyle_admin_index]
  layout "marketplace", only: [:index]

  def index
    @lifestyle = Lifestyle.order('created_at DESC')
  end

  def lifestyle_admin_index
    @lifestyle = Lifestyle.order('created_at DESC')
  end

  def new
    @lifestyle = Lifestyle.new
  end

  def create
    @lifestyle = Lifestyle.new(lifestyle_params)
    if @lifestyle.save
      flash[:notice] = "Successfully created lifestyle article."
      redirect_to '/lifestyle_admin_index'
    else
      render :new
    end
  end

  private

  def lifestyle_params
    params.require(:lifestyle).permit(:link, :image, :intro, :title, :category)
  end
end
