class MallsController < ApplicationController
  before_action :set_mall, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @malls = policy_scope(Mall).includes(:stores).order(:name).page(params[:page]).per(12)
  end

  def show
    authorize @mall
    @stores = @mall.stores.active.includes(:user).page(params[:page]).per(12)
  end

  def new
    @mall = Mall.new
    authorize @mall
  end

  def create
    @mall = Mall.new(mall_params)
    authorize @mall
    
    if @mall.save
      flash[:notice] = "Mall created successfully!"
      redirect_to @mall
    else
      flash.now[:alert] = "There was a problem creating the mall."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @mall
  end

  def update
    authorize @mall
    
    if @mall.update(mall_params)
      flash[:notice] = "Mall updated successfully!"
      redirect_to @mall
    else
      flash.now[:alert] = "There was a problem updating the mall."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @mall
    
    if @mall.stores.any?
      flash[:alert] = "Cannot delete mall with associated stores."
      redirect_to @mall
    elsif @mall.destroy
      flash[:notice] = "Mall deleted successfully!"
      redirect_to malls_path
    else
      flash[:alert] = "There was a problem deleting the mall."
      redirect_to @mall
    end
  end

  private

  def set_mall
    @mall = Mall.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Mall not found."
    redirect_to malls_path
  end

  def mall_params
    params.require(:mall).permit(:name, :description, :address, :contact_email, :contact_phone, :active)
  end
end

