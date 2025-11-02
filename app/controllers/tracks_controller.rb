class TracksController < ApplicationController
  include RoleBasedAccess
  
  before_action :authenticate_user!, except: [:show, :music]
  before_action :require_admin_or_artist, only: [:new, :create, :update, :edit, :destroy]
  layout "admin", only: [:new, :create, :update, :admin_all_music, :index, :edit]
  
  private
  
  def require_admin_or_artist
    unless current_user&.admin? || current_user&.artist?
      flash[:alert] = "You need to be an admin or artist to perform this action."
      redirect_to root_path
    end
  end
  
  def index
    @tracks = Track.order('created_at DESC')
    @artists = Artist.order('created_at DESC')
  end

  def music
    @tracks = Track.order('created_at DESC')
    #@artists = Artist.all
  end

  def admin_all_music    
    @tracks = Track.order('created_at DESC')
    #@artists = Artist.all
  end

  #def admin_track_index
  #  @tracks = Track.where(:artist_id => params[:artist_id]) 
  #end

  def new
    if(params.has_key?(:album_id))
      @number_of_tracks = "multiple"
      @page_heading = "Add tracks to album"
      @track = Track.new(:album_id => params[:album_id])
    else
      @number_of_tracks = "single"
      @page_heading = "Add new track"
      @track = Track.new
    end
    
    ##@artist_id = current_admin.id 
  end

  def create
    track_params_data = track_params
    if track_params_data[:album_id].present?
      tracks = track_params_data[:tracks]
      album_id = track_params_data[:album_id]
      title = track_params_data[:title]
      artist_name = track_params_data[:artist_name]

      if tracks.present?
        tracks.each do |track|
          @track = Track.new
          @track.album_id = album_id
          @track.title = title
          @track.artist_name = artist_name
          @track.track = track
          @track.save
        end
      end
      redirect_to '/admin_album_index'
    else
      @track = Track.new(track_params_data)
      if @track.save
        flash[:notice] = "Successfully uploaded track."
        redirect_to '/admin_all_music'
      else
        render :new
      end
    end
  end

  def show
    @track = Track.find(params[:id])
  end

  def edit
    @track = Track.find(params[:id])
  end

  def update
    @track = Track.find(params[:id])
    if @track.update_attributes(track_params)
      flash[:notice] = "Successfully updated track."
      redirect_to tracks_path
    else
      render :edit
    end
  end


  private
  def track_params
    params.require(:track).permit(:title,:intro,:thumb,:track,:image,:category,:album_id, :artist_name, :tracks)
  end

end
