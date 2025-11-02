class DashboardsController < ApplicationController
  include RoleBasedAccess
  include Impersonation

  before_action :authenticate_user!
  
  # Admin dashboard
  def admin
    require_admin
    @stats = {
      total_users: User.count,
      djs: User.djs.count,
      artists: User.artists.count,
      photographers: User.photographers.count,
      videographers: User.videographers.count,
      curators: User.curators.count,
      designers: User.designers.count,
      editors: User.editors.count,
      members: User.where(role: :member).count,
      recent_users: User.order(created_at: :desc).limit(5),
      galleries_count: Gallery.count,
      features_count: Feature.count,
      videos_count: Video.count,
      tracks_count: Track.count,
      albums_count: Album.count,
      artists_count: Artist.count,
      lifestyles_count: Lifestyle.count,
      events_count: Event.count,
      banners_count: MainBanner.count
    }
    
    @recent_galleries = Gallery.order(created_at: :desc).limit(5)
    @recent_features = Feature.order(created_at: :desc).limit(5)
    @recent_tracks = Track.order(created_at: :desc).limit(5)
    @recent_events = Event.order(created_at: :desc).limit(5)
    
    render :admin, layout: 'admin'
  end

  # DJ dashboard
  def dj
    require_dj
    
    @user = current_user
    @events = Event.order(date: :desc).limit(10)
    @upcoming_events = Event.where("date >= ?", Date.today).order(date: :asc).limit(5)
    @past_events = Event.where("date < ?", Date.today).order(date: :desc).limit(5)
    @tracks = Track.order(created_at: :desc).limit(10)
    
    render :dj, layout: 'admin'
  end

  # Artist dashboard
  def artist
    require_artist
    
    @user = current_user
    @tracks = Track.order(created_at: :desc).limit(20)
    @albums = Album.order(created_at: :desc).limit(10)
    
    # If there's an association between users and artists/tracks, filter by current user
    # For now, showing all tracks and albums
    @user_tracks = Track.all
    @user_albums = Album.all
    
    @stats = {
      total_tracks: Track.count,
      total_albums: Album.count,
      my_tracks: @user_tracks.count,
      my_albums: @user_albums.count
    }
    
    render :artist, layout: 'admin'
  end

  # Photographer dashboard
  def photographer
    require_photographer
    
    @user = current_user
    @galleries = Gallery.order(created_at: :desc).limit(10)
    @recent_galleries = Gallery.order(created_at: :desc).limit(5)
    @images_count = Image.count
    
    @stats = {
      total_galleries: Gallery.count,
      total_images: Image.count,
      my_galleries: @galleries.count
    }
    
    render :photographer, layout: 'admin'
  end

  # Videographer dashboard
  def videographer
    require_videographer
    
    @user = current_user
    @videos = Video.order(created_at: :desc).limit(20)
    @recent_videos = Video.order(created_at: :desc).limit(5)
    
    @stats = {
      total_videos: Video.count,
      my_videos: @videos.count
    }
    
    render :videographer, layout: 'admin'
  end

  # Curator dashboard
  def curator
    require_curator
    
    @user = current_user
    @features = Feature.order(created_at: :desc).limit(20)
    @recent_features = Feature.order(created_at: :desc).limit(5)
    @galleries = Gallery.order(created_at: :desc).limit(5)
    @videos = Video.order(created_at: :desc).limit(5)
    
    @stats = {
      total_features: Feature.count,
      total_galleries: Gallery.count,
      total_videos: Video.count,
      my_features: @features.count
    }
    
    render :curator, layout: 'admin'
  end

  # Designer dashboard
  def designer
    require_designer
    
    @user = current_user
    @banners = MainBanner.order(created_at: :desc).limit(20)
    @recent_banners = MainBanner.order(created_at: :desc).limit(5)
    
    @stats = {
      total_banners: MainBanner.count,
      my_banners: @banners.count,
      active_banners: MainBanner.count # Could add active flag later
    }
    
    render :designer, layout: 'admin'
  end

  # Editor dashboard
  def editor
    require_editor
    
    @user = current_user
    @features = Feature.order(created_at: :desc).limit(20)
    @recent_features = Feature.order(created_at: :desc).limit(5)
    @galleries = Gallery.order(created_at: :desc).limit(5)
    @videos = Video.order(created_at: :desc).limit(5)
    @tracks = Track.order(created_at: :desc).limit(5)
    
    @stats = {
      total_features: Feature.count,
      total_galleries: Gallery.count,
      total_videos: Video.count,
      total_tracks: Track.count,
      pending_review: 0 # Could add review status later
    }
    
    render :editor, layout: 'admin'
  end

  # Generic dashboard route that redirects based on role
  def show
    redirect_to dashboard_path_for(current_user)
  end

  private

  def dashboard_path_for(user)
    case user.role
    when 'admin'
      admin_dashboard_path
    when 'dj'
      dj_dashboard_path
    when 'artist'
      artist_dashboard_path
    when 'photographer'
      photographer_dashboard_path
    when 'videographer'
      videographer_dashboard_path
    when 'curator'
      curator_dashboard_path
    when 'designer'
      designer_dashboard_path
    when 'editor'
      editor_dashboard_path
    else
      root_path
    end
  end
end

