class ImagesController < ApplicationController
  before_action :authenticate_admin!
  layout "admin", only: [:new, :create, :update, :edit, :destroy]

  def new
    @image = Image.new(:gallery_id => params[:gallery_id])
  end

  def create
    image_params = params.require(:image).permit(:gallery_id, :name, :images, :remote_image_url, :file)
    @name = image_params[:name]
    @gallery_id = image_params[:gallery_id]
    @images = image_params[:images]

    if @images.present?
      @images.each do |image|
        @image = Image.new
        @image.gallery_id = @gallery_id
        @image.name = @name
        @image.image = image
        @image.save
      end
    end

    redirect_to @image.try(:gallery) || galleries_path
    # if @image.save
    #   flash[:notice] = "Successfully created painting."
    #   redirect_to @image.gallery
    # else
    #   render :action => 'new'
    # end
  end

  def edit
    @image = Image.find(params[:id])
  end

  def update
    @image = Image.find(params[:id])
    if @image.update_attributes(image_params)
      flash[:notice] = "Successfully updated image."
      redirect_to @image.gallery
    else
      render :edit
    end
  end

  def destroy
    @image = Image.find(params[:id])
    gallery = @image.gallery
    @image.destroy
    flash[:notice] = "Successfully destroyed image."
    redirect_to gallery
  end

  private
  def image_params
    params.require(:image).permit(:gallery_id, :name, :images, :remote_image_url, :file)
  end

end
