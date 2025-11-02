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
      banners_count: MainBanner.count,
      ticket_listings_count: TicketListing.count,
      available_tickets_count: TicketListing.available.count,
      sold_tickets_count: TicketListing.where(status: 'sold').count,
      total_revenue: TicketListing.where(status: 'sold').sum { |t| t.price * t.sold_quantity }
    }
    
    @recent_galleries = Gallery.order(created_at: :desc).limit(5)
    @recent_features = Feature.order(created_at: :desc).limit(5)
    @recent_tracks = Track.order(created_at: :desc).limit(5)
    @recent_events = Event.order(created_at: :desc).limit(5)
    @recent_ticket_listings = TicketListing.includes(:user, :event).order(created_at: :desc).limit(5)
    
    # Ad Revenue Statistics
    @ad_stats = calculate_ad_revenue_stats
    
    render :admin, layout: 'admin'
  end

  # Ad Revenue Dashboard - comprehensive view
  def ad_revenue
    require_admin
    
    # Date range filtering (default to last 30 days)
    @date_range = params[:date_range] || '30'
    days = @date_range.to_i
    @start_date = days.days.ago.beginning_of_day
    @end_date = Date.current.end_of_day
    
    @ad_stats = calculate_ad_revenue_stats(@start_date, @end_date)
    @page_stats = calculate_page_stats(@start_date, @end_date)
    @revenue_by_page = calculate_revenue_by_page(@start_date, @end_date)
    @revenue_trends = calculate_revenue_trends(@start_date, @end_date)
    @top_ads = calculate_top_ads(@start_date, @end_date)
    @ad_performance_by_spot = calculate_ad_performance_by_spot(@start_date, @end_date)
    
    render :ad_revenue, layout: 'admin'
  end

  private

  def calculate_ad_revenue_stats(start_date = nil, end_date = nil)
    scope = AdSpot.active
    
    # Potential revenue from all active ad spots (based on pricing)
    potential_revenue = AdSpot.active.sum(:price)
    
    # Active ads count
    active_ads = Ad.active.count
    
    # Total impressions
    total_impressions = Ad.sum(:impressions)
    
    # Total clicks
    total_clicks = Ad.sum(:clicks)
    
    # Overall CTR
    overall_ctr = total_impressions > 0 ? (total_clicks.to_f / total_impressions * 100) : 0
    
    # Active ad spots
    active_spots = AdSpot.active.count
    
    # Ads with dates
    current_ads = Ad.active.current.count
    
    # Filter by date range if provided
    if start_date && end_date
      # For date-filtered stats, we'd need to track revenue differently
      # For now, we'll use the ad spot prices as potential revenue
      filtered_ads = Ad.where(created_at: start_date..end_date)
      filtered_impressions = filtered_ads.sum(:impressions)
      filtered_clicks = filtered_ads.sum(:clicks)
      filtered_ctr = filtered_impressions > 0 ? (filtered_clicks.to_f / filtered_impressions * 100) : 0
      
      {
        potential_revenue: potential_revenue,
        active_ads: filtered_ads.active.count,
        total_impressions: filtered_impressions,
        total_clicks: filtered_clicks,
        overall_ctr: filtered_ctr.round(2),
        active_spots: active_spots,
        current_ads: filtered_ads.active.current.count,
        date_range: "#{start_date.strftime('%b %d')} - #{end_date.strftime('%b %d, %Y')}"
      }
    else
      {
        potential_revenue: potential_revenue,
        active_ads: active_ads,
        total_impressions: total_impressions,
        total_clicks: total_clicks,
        overall_ctr: overall_ctr.round(2),
        active_spots: active_spots,
        current_ads: current_ads
      }
    end
  end

  def calculate_page_stats(start_date, end_date)
    pages = AdSpot.select(:page).distinct.pluck(:page)
    
    pages.map do |page|
      spots = AdSpot.active.for_page(page)
      ads = Ad.joins(:ad_spot).where(ad_spots: { page: page })
      
      if start_date && end_date
        ads = ads.where(created_at: start_date..end_date)
      end
      
      {
        page: page.titleize,
        spots_count: spots.count,
        ads_count: ads.count,
        active_ads: ads.active.count,
        impressions: ads.sum(:impressions),
        clicks: ads.sum(:clicks),
        potential_revenue: spots.sum(:price),
        ctr: ads.sum(:impressions) > 0 ? (ads.sum(:clicks).to_f / ads.sum(:impressions) * 100).round(2) : 0
      }
    end
  end

  def calculate_revenue_by_page(start_date, end_date)
    AdSpot.active
          .joins("LEFT JOIN ads ON ads.ad_spot_id = ad_spots.id")
          .where("ads.created_at IS NULL OR ads.created_at >= ?", start_date)
          .where("ads.created_at IS NULL OR ads.created_at <= ?", end_date)
          .group(:page)
          .sum(:price)
          .transform_keys { |k| k.titleize }
  end

  def calculate_revenue_trends(start_date, end_date)
    # Group by day for the last 30 days
    days = ((end_date - start_date).to_i / 1.day).round
    days = [days, 30].min
    
    trend_data = []
    (days.days.ago.to_date..Date.current).each do |date|
      day_start = date.beginning_of_day
      day_end = date.end_of_day
      
      ads = Ad.where(created_at: day_start..day_end)
      
      trend_data << {
        date: date.strftime('%b %d'),
        impressions: ads.sum(:impressions),
        clicks: ads.sum(:clicks),
        new_ads: ads.count
      }
    end
    
    trend_data
  end

  def calculate_top_ads(start_date, end_date)
    Ad.joins(:ad_spot)
      .where(created_at: start_date..end_date)
      .order(impressions: :desc)
      .limit(10)
      .map do |ad|
        {
          id: ad.id,
          title: ad.title,
          page: ad.ad_spot.page.titleize,
          position: ad.ad_spot.position.titleize,
          impressions: ad.impressions,
          clicks: ad.clicks,
          ctr: ad.click_through_rate,
          advertiser: ad.advertiser_name,
          spot_price: ad.ad_spot.price
        }
      end
  end

  def calculate_ad_performance_by_spot(start_date, end_date)
    AdSpot.active
          .joins(:ads)
          .where(ads: { created_at: start_date..end_date })
          .group('ad_spots.id', 'ad_spots.name', 'ad_spots.page', 'ad_spots.position', 'ad_spots.price')
          .select('ad_spots.id, ad_spots.name, ad_spots.page, ad_spots.position, ad_spots.price,
                   COUNT(ads.id) as ads_count,
                   SUM(ads.impressions) as total_impressions,
                   SUM(ads.clicks) as total_clicks')
          .map do |spot|
            impressions = spot.total_impressions.to_i
            clicks = spot.total_clicks.to_i
            ctr = impressions > 0 ? (clicks.to_f / impressions * 100).round(2) : 0
            
            {
              id: spot.id,
              name: spot.name,
              page: spot.page.titleize,
              position: spot.position.titleize,
              price: spot.price.to_f,
              ads_count: spot.ads_count.to_i,
              impressions: impressions,
              clicks: clicks,
              ctr: ctr,
              revenue_potential: spot.price.to_f * spot.ads_count.to_i
            }
          end
          .sort_by { |s| -s[:impressions] }
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

  # Member dashboard - ticket marketplace focused
  def member
    @user = current_user
    @ticket_listings = current_user.ticket_listings.includes(:event).order(created_at: :desc).limit(5)
    @available_count = current_user.ticket_listings.available.count
    @sold_count = current_user.ticket_listings.where(status: 'sold').count
    @total_revenue = current_user.ticket_listings.where(status: 'sold')
                                   .sum { |t| t.price * t.sold_quantity }
    @upcoming_events = Event.where("date >= ?", Date.today).order(date: :asc).limit(5)
    @marketplace_tickets = TicketListing.available.includes(:event, :user).order(created_at: :desc).limit(6)
    
    render :member, layout: 'admin'
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
    when 'member'
      member_dashboard_path
    else
      root_path
    end
  end
end

