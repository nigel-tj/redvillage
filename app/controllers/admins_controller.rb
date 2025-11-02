class AdminsController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def index
    # Dashboard statistics
    @galleries_count = Gallery.count
    @features_count = Feature.count
    @videos_count = Video.count
    @tracks_count = Track.count
    @albums_count = Album.count
    @artists_count = Artist.count
    @lifestyles_count = Lifestyle.count
    @events_count = Event.count

    # Recent items
    @recent_galleries = Gallery.order(created_at: :desc).limit(5)
    @recent_features = Feature.order(created_at: :desc).limit(5)
    @recent_tracks = Track.order(created_at: :desc).limit(5)
  end
end
