require 'soundcloud'
class MusicsController < ApplicationController
  before_action :authenticate_admin!, except: [:show,:music]
  layout "admin", only: [:new, :create, :update, :admin_index, :index]

  def index
    @tracks = Music.order('created_at DESC')
    @artists = Artist.order('created_at DESC')
  end

  def music
    @tracks = Track.order('created_at DESC')
    @artists = Artist.order('created_at DESC')
  end

  def admin_index
    #@tracks = Music.all
    @tracks = Track.order('created_at DESC')
    @artists = Artist.order('created_at DESC')
  end

  #def admin_music_index
  #  @tracks = Music.where(:artist_id => params[:artist_id]) 
  #end

  def new
    @music = Track.new
    @artist_id = current_admin.id 
  end

  def create
    @music = Track.new(music_params)
    if @music.save
      flash[:notice] = "Successfully uploaded track."
      render :action => '/admin_index'
    else
      render :action => 'new'
    end
  end

  def show
    @music = Music.find(params[:id])
  end


  private
  def music_params
    params.require(:music).permit(:track_title,:intro,:thumb,:track,:image,:artist_id,:category)
  end

end
