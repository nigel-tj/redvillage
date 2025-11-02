class VisitorsController < ApplicationController
  layout "new_look_layout", only: [:index, :about_us, :event_new_look, :events_list_new_look, :gallery, :top_dj, :schedule, :blog, :blog_details, :faq, :contact_us, :team]

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
    # Team page - displays team members with public profiles
    @djs = User.djs.joins(:profile)
                .where(profiles: { public_profile: true })
                .where.not(profiles: { profile_picture: nil })
                .limit(12)
    @artists = User.artists.joins(:profile)
                    .where(profiles: { public_profile: true })
                    .where.not(profiles: { profile_picture: nil })
                    .limit(12)
    @photographers = User.photographers.joins(:profile)
                         .where(profiles: { public_profile: true })
                         .where.not(profiles: { profile_picture: nil })
                         .limit(6)
    @videographers = User.videographers.joins(:profile)
                         .where(profiles: { public_profile: true })
                         .where.not(profiles: { profile_picture: nil })
                         .limit(6)
  end

  def top_dj
    # Top DJ page - displays DJs with public profiles
    @djs = User.djs.joins(:profile)
                .where(profiles: { public_profile: true })
                .where.not(profiles: { profile_picture: nil })
                .order('profiles.updated_at DESC')
                .limit(12)
  end

  def schedule
    # Event schedule page
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
    # About us page
  end

  def blog
    # Blog listing page
  end

  def blog_details
    # Individual blog post page
  end

  def faq
    # Frequently asked questions page
  end

  def contact_us
    # Contact us page
  end

  def social
    # Social media integration page
    # TODO: Implement modern social media integration
  end

  def news
    # News and social media feed page
    @features = Feature.order(created_at: :desc).limit(20)
  end

  def portfolio
    # Portfolio/download page
    # render pdf: "public/docs/Proposal-template.pdf"
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
