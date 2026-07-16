class GalleriesController < ApplicationController
  include RoleBasedAccess
  
  # Public: browsing galleries is open to everyone.
  before_action :authenticate_user!, except: [:index, :show, :show_gallery]
  before_action :require_gallery_manager, only: [:new, :create, :update, :edit, :destroy, :admin_show]
  before_action :authorize_gallery, only: [:update, :edit, :destroy]
  layout "admin", only: [:new, :create, :update, :admin_show, :edit]
  layout "marketplace", only: [:index, :show, :show_gallery]
  
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
  
  def authorize_gallery
    authorize(@gallery || Gallery)
  end

  def gallery_params
    params.require(:gallery).permit(:name,:category,:image)
  end

end
