class GalleriesController < ApplicationController
  include RoleBasedAccess
  
  before_action :authenticate_user!, except: [:show_gallery]
  before_action :require_photographer_or_admin, only: [:new, :create, :update, :edit, :destroy]
  layout "admin", only: [:new, :create, :update, :admin_show, :index, :show]
  
  private
  
  def require_photographer_or_admin
    unless current_user&.photographer? || current_user&.admin? || current_user&.curator? || current_user&.editor?
      flash[:alert] = "You need photographer, curator, editor, or admin access to perform this action."
      redirect_to root_path
    end
  end

  def index
    @galleries = Gallery.order('created_at DESC')
  end

  def show
    @gallery = Gallery.find(params[:id])
    @gallery.images = Image.where(:gallery_id => params[:id])
  end

  def admin_show
    @photo_gallery = Image.where(:gallery_id => params[:id])
  end

  def show_gallery
    @gallery = Gallery.find(params[:id])
    #@all_images = Image.where(:gallery_id => params[:id])
  end


  def new
    @gallery = Gallery.new
  end

  def create
    @gallery = Gallery.new(gallery_params)
    if @gallery.save
      flash[:notice] = "Successfully created gallery."
      render :action => 'admin_show'
    else
      render :action => 'new'
    end
  end

  def edit
    @gallery = Gallery.find(params[:id])
  end

  def update
    @gallery = Gallery.find(params[:id])
    if @gallery.update_attributes(gallery_params)
      flash[:notice] = "Successfully updated gallery."
      redirect_to @gallery
    else
      render :edit
    end
  end

  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy
    flash[:notice] = "Successfully destroyed gallery."
    redirect_to galleries_url
  end

  private
  def gallery_params
    params.require(:gallery).permit(:name,:category,:image)
  end

end
