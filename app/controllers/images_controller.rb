class ImagesController < ApplicationController
  before_action :authenticate_admin!
  layout "admin", only: [:new, :create, :update, :new, :edit, :destroy]

  def new
    @image = Image.new(:gallery_id => params[:gallery_id])
  end

  def create
    @name  = params[:image][:name]
    @gallery_id = params[:image][:gallery_id]
    @images = params[:image][:images]
    @images.each do |image|
      @image = Image.new
      @image.gallery_id = @gallery_id
      @image.name = @name
      @image.image = image
      @image.save
    end
    
    redirect_to @image.gallery
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
    if @image.update_attributes(painting_params)
      flash[:notice] = "Successfully updated painting."
      redirect_to @image.gallery
    else
      render :action => 'edit'
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    flash[:notice] = "Successfully destroyed painting."
    redirect_to @image.gallery
  end

  private
  def painting_params
    params.require(:image).permit(:gallery_id, :name, :images, :remote_image_url,:file)
  end

end
