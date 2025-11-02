class VideosController < ApplicationController
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_videographer_or_admin, only: [:new, :create, :update, :edit, :destroy]
  layout "admin", only: [:new, :create, :update, :all_videos]

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
  
  def require_videographer_or_admin
    unless current_user&.videographer? || current_user&.admin? || current_user&.curator? || current_user&.editor?
      flash[:alert] = "You need videographer, curator, editor, or admin access to perform this action."
      redirect_to root_path
    end
  end

  def video_params
    params.require(:video).permit(:link,:category)
  end
end
