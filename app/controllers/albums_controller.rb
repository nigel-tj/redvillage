class AlbumsController < ApplicationController
  before_action :authenticate_admin!, except: [:index, :show]

  layout "admin", only: [:new, :create, :update, :admin_show_album, :admin_album_index]

  def index
    @albums = Album.all
  end

  def admin_album_index
    @albums = Album.all
  end

  def show
    @album = Album.find(params[:id])
    @album_tracks = Track.where(album_id: params[:id])
  end

  def admin_show_album
    @album = Album.find(params[:id])
    @album_tracks = Track.where(album_id: params[:id])
    render :show
  end

  def new
    @album = Album.new
  end

  def create
    @album = Album.new(album_params)
    if @album.save
      flash[:notice] = "Successfully created album."
      redirect_to admin_show_album_path(@album)
    else
      render :new
    end
  end

  def edit
    @album = Album.find(params[:id])
  end

  def update
    @album = Album.find(params[:id])
    if @album.update_attributes(album_params)
      flash[:notice] = "Successfully updated album."
      redirect_to @album
    else
      render :edit
    end
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy
    flash[:notice] = "Successfully destroyed album."
    redirect_to albums_path
  end

  private
  def album_params
    params.require(:album).permit(:name,:cover, :artist_name, :artist_id)
  end

end
