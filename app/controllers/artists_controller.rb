class ArtistsController < ApplicationController
  include RoleBasedAccess

  # Public: artist directory + individual artist pages are open.
  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_curator_or_admin, only: [:new, :create, :edit, :update, :admin_artist_index]
  layout "admin", only: [:new, :create, :update, :admin_artist_index, :edit]
  layout "marketplace", only: [:index, :show]

  def index
    # Show both Artist model records and User artists with public profiles
    @artists_model = Artist.all
    @user_artists = User.artists.joins(:profile)
                        .where(profiles: { public_profile: true })
                        .limit(20)
  end

  def new
    @artist = Artist.new 
    #render :layout => 'admin'
  end

  def admin_artist_index
    # Show both Artist model records and Users with artist role
    @artists_model = Artist.all
    @user_artists = User.artists.includes(:profile).order(:name)
  end

  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      flash[:notice] = "Successfully created artist."
      redirect_to '/admin_artist_index'
    else
      render :action => 'new'
    end
  end

  def edit
    @artist = Artist.find(params[:id])
  end

  def update
  end

  def show
    @artist = Artist.find(params[:id])
    @songs = Track.where(:artist_id => params[:id])
  end

  def artist
  end

  private

  def artist_params
    params.require(:artist).permit(:name, :email, :cell_number, :bio, :cover, :profile_picture, :category)
  end
end
