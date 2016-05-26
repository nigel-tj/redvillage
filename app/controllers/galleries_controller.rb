class GalleriesController < ApplicationController
  before_action :authenticate_admin!, except: [:index,:show]
  layout "admin", only: [:new, :create, :update, :admin_show]

  def index
    @galleries = Gallery.all
  end

  def show
    @gallery = Gallery.find(params[:id])
  end

  def admin_show
    @gallery = Gallery.all
  end

  def new
    @gallery = Gallery.new
  end

  def create
    @gallery = Gallery.new(gallery_params)
    if @gallery.save
      flash[:notice] = "Successfully created gallery."
       redirect_to '/admin_show'
    else
      render :action => 'new'
    end
  end

  def edit
    @gallery = Gallery.find(params[:id])
  end

  def update
    @gallery = Gallery.find(params[:id])
    if @gallery.update_attributes(params[:gallery])
      flash[:notice] = "Successfully updated gallery."
      redirect_to gallery_url
    else
      render :action => 'edit'
    end
    render :layout => 'admin'
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
