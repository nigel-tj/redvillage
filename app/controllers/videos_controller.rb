class VideosController < ApplicationController
  include RoleBasedAccess

  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_video_manager, only: [:new, :create, :update, :edit, :destroy, :all_videos]
  layout "admin", only: [:new, :create, :update, :edit, :all_videos]

  def index
    @videos = Video.order('created_at DESC')
  end

  def all_videos
    @videos = Video.order('created_at DESC')
  end

  def test
    @videos = Video.order('created_at DESC')
  end

  def new
    @video = Video.new
  end

  def destroy
    @video = Video.find(params[:id])
    @video.destroy
    flash[:success] = 'Video deleted!'
    redirect_to '/all_videos'
  end

  def edit
    @video = Video.find(params[:id])
  end

  def show
    @video = Video.find(params[:id])
  end
  
  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = 'Video added!'
      redirect_to '/all_videos'
    else
      render :new
    end
  end
  
  def update
    @video = Video.find(params[:id])
    if @video.update(video_params)
      flash[:success] = 'Video updated!'
      redirect_to '/all_videos'
    else
      render :edit
    end
  end

  private
  
  def video_params
    params.require(:video).permit(:link,:category)
  end
end
