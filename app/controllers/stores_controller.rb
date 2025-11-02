class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy, :activate, :deactivate]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :my_stores]
  
  def index
    @stores = policy_scope(Store).includes(:user, :mall).page(params[:page]).per(12)
    @banners = MainBanner.all if defined?(MainBanner)
    @malls = Mall.active if params[:mall_id].present?
  end

  def show
    authorize @store
  end

  def new
    @store = Store.new
    authorize @store
    @malls = Mall.active.order(:name)
  end

  def create
    @store = current_user.stores.build(store_params)
    authorize @store
    
    if @store.save
      flash[:notice] = "Store created successfully!"
      redirect_to @store
    else
      @malls = Mall.active.order(:name)
      flash.now[:alert] = "There was a problem creating your store."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @store
    @malls = Mall.active.order(:name)
  end

  def update
    authorize @store
    
    if @store.update(store_params)
      flash[:notice] = "Store updated successfully!"
      redirect_to @store
    else
      @malls = Mall.active.order(:name)
      flash.now[:alert] = "There was a problem updating your store."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @store
    
    if @store.destroy
      flash[:notice] = "Store deleted successfully!"
      redirect_to stores_path
    else
      flash[:alert] = "There was a problem deleting the store."
      redirect_to @store
    end
  end

  def my_stores
    @stores = current_user.stores.includes(:mall).order(created_at: :desc).page(params[:page]).per(12)
    authorize Store.new
  end

  def activate
    authorize @store, :activate?
    @store.activate!
    flash[:notice] = "Store activated successfully!"
    redirect_to @store
  end

  def deactivate
    authorize @store, :deactivate?
    @store.deactivate!
    flash[:notice] = "Store deactivated successfully!"
    redirect_to @store
  end

  private

  def set_store
    @store = Store.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Store not found."
    redirect_to stores_path
  end

  def store_params
    params.require(:store).permit(:name, :email, :contact_number, :description, :cover, :mall_id, :active)
  end
end
