class PaintingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_gallery_manager

  def new
    @painting = Painting.new(:gallery_id => params[:gallery_id])
  end

  def create
    @name  = params[:painting][:name]
    @gallery_id = params[:painting][:gallery_id]
    @images = params[:painting][:images]
    @images.each do |image|
      @painting = Painting.new
      @painting.gallery_id = @gallery_id
      @painting.name = @name
      @painting.image = image
      @painting.save
    end
    
    redirect_to @painting.gallery
    # if @painting.save
    #   flash[:notice] = "Successfully created painting."
    #   redirect_to @painting.gallery
    # else
    #   render :action => 'new'
    # end
  end

  def edit
    @painting = Painting.find(params[:id])
  end

  def update
    @painting = Painting.find(params[:id])
    if @painting.update_attributes(painting_params)
      flash[:notice] = "Successfully updated painting."
      redirect_to @painting.gallery
    else
      render :action => 'edit'
    end
  end

  def destroy
    @painting = Painting.find(params[:id])
    @painting.destroy
    flash[:notice] = "Successfully destroyed painting."
    redirect_to @painting.gallery
  end

  private

  def painting_params
    params.require(:painting).permit(:gallery_id, :name, :images, :remote_image_url)
  end

end
