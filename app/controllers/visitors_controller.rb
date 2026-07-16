class VisitorsController < ApplicationController
  # Public marketing pages share ONE Bootstrap 5 marketplace skin (rv_theme).
  layout "marketplace"

  def index
    @banners = MainBanner.where(page: "home")
    @trends = Feature.all
    @videos = Video.order(created_at: :desc)
    @events = Event.order(date: :asc).limit(4)
  end

  def videos
    @videos = Video.order(created_at: :desc)
  end

  def team
    # Team page - displays creative-community members with public profiles.
    # NOTE: we deliberately do NOT filter on profile_picture presence — most demo
    # users have no uploaded avatar, and the profile_card partial renders a
    # placeholder icon for those. Gating on profile_picture previously left the
    # page empty.
    @djs = User.djs.joins(:profile).where(profiles: { public_profile: true }).limit(12)
    @artists = User.artists.joins(:profile).where(profiles: { public_profile: true }).limit(12)
    @photographers = User.photographers.joins(:profile).where(profiles: { public_profile: true }).limit(6)
    @videographers = User.videographers.joins(:profile).where(profiles: { public_profile: true }).limit(6)
    @curators = User.curators.joins(:profile).where(profiles: { public_profile: true }).limit(6)
    @designers = User.designers.joins(:profile).where(profiles: { public_profile: true }).limit(6)
    @editors = User.editors.joins(:profile).where(profiles: { public_profile: true }).limit(6)
  end

  def top_dj
    # Top DJ page - displays DJs with public profiles.
    # NOTE: deliberately NOT gating on profile_picture (same fix as /team and the
    # profiles_listings pages — no seed user has an uploaded avatar). DJs render
    # with the shared _profile_card partial for a consistent look across the site.
    @djs = User.djs.joins(:profile)
                .where(profiles: { public_profile: true })
                .order('profiles.updated_at DESC')
                .limit(12)
  end

  def schedule
    @events = Event.order(date: :asc)
  end

  def event_new_look
    if params[:id]
      @event = Event.find(params[:id])
    else
      # Show the first featured event if available, otherwise show the first upcoming event
      @event = Event.where(featured: true).order(date: :asc).first || Event.order(date: :asc).first
    end

    # Load other events for the "More Upcoming Events" section
    @featured_events = Event.where(featured: true).where.not(id: @event&.id).order(date: :asc).limit(3)
    @other_events = Event.where.not(id: @event&.id)
                        .where.not(id: @featured_events.pluck(:id))
                        .order(date: :asc)
                        .limit(3 - @featured_events.size)
    @other_events = @featured_events + @other_events
  end

  def about_us
    @stats = {
      stores: Store.count,
      events: Event.count,
      artists: User.artists.joins(:profile).count,
      creators: User.content_creators.joins(:profile).count
    }
  end

  def blog
    @features = Feature.order(created_at: :desc)
  end

  def blog_details
    @features = Feature.order(created_at: :desc)
    @feature = params[:id] ? Feature.find_by(id: params[:id]) : @features.first
  end

  def faq
    # Frequently asked questions page (static content in the view)
  end

  def contact_us
    # Contact us page (static content in the view)
  end

  def social
    # Social media integration page
  end

  def news
    # News and social media feed page
    @features = Feature.order(created_at: :desc).limit(20)
  end

  def portfolio
    # Portfolio/download page
  end

  def gallery
    @galleries = Gallery.all
  end

  def events_list_new_look
    @events = Event.order(date: :asc)
  end

  def featured_events
    @events = Event.where(featured: true).order(date: :asc)
    render :events_list_new_look
  end
end
