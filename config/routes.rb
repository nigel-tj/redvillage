Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    passwords: 'admins/passwords',
    registrations: 'admins/registrations'
  }

  # User management routes (for admins)
  resources :users, only: [:index, :show, :edit, :update, :destroy]

  # Standard RESTful routes
  resources :lifestyles
  resources :albums
  resources :stores
  resources :tracks
  resources :main_banners
  resources :galleries
  resources :images
  resources :features
  resources :videos
  resources :artists
  resources :events do
    resources :ticket_listings, only: [:index, :new]
  end
  resources :ticket_listings do
    collection do
      get 'my_tickets', to: 'ticket_listings#my_tickets', as: :my_tickets
    end
  end
  
  # Simple alias for my tickets - cleaner URL
  get 'my_tickets', to: 'ticket_listings#my_tickets', as: :my_tickets
  
  # Profile routes
  resources :profiles, only: [:show, :edit, :update]
  get '/my_profile', to: 'profiles#my_profile', as: :my_profile
  
  # Public profile listings
  get '/djs', to: 'profiles_listings#djs', as: :djs_listing
  get '/artists_listing', to: 'profiles_listings#artists', as: :artists_listing
  get '/photographers', to: 'profiles_listings#photographers', as: :photographers_listing
  get '/videographers', to: 'profiles_listings#videographers', as: :videographers_listing
  get '/curators', to: 'profiles_listings#curators', as: :curators_listing
  get '/designers', to: 'profiles_listings#designers', as: :designers_listing
  get '/creators', to: 'profiles_listings#all_creators', as: :all_creators_listing

  # Custom routes (non-RESTful)
  get 'visitors/news'
  get 'visitors/gallery'
  get 'visitors/videos'
  get 'visitors/social'
  get 'visitors/events'
  get 'visitors/contact'
  get 'videos/test'
  get 'visitors/stage'
  get 'visitors/show_gallery'

  # Facebook callback
  get "/callback" => "facebook#callback"
  get "/facebook_profile" => "facebook#facebook_profile"

  # Custom named routes (e.g., for specific actions)
  get '/gallery', to: 'visitors#gallery'
  get '/gallery_new_look', to: 'visitors#gallery'
  get '/gallery/:id', to: 'galleries#show_gallery', as: :show_gallery
  get '/music', to: 'tracks#music'
  get '/news', to: 'features#index'
  get '/about_us', to: 'visitors#about_us'
  get '/event_new_look', to: 'visitors#event_new_look'
  get '/event_new_look/:id', to: 'visitors#event_new_look', as: 'event_new_look_with_id'
  get '/featured_events', to: 'visitors#featured_events', as: 'featured_events'
  get '/social', to: 'visitors#social'
  get '/videos', to: 'videos#index'
  get '/top_dj', to: 'visitors#top_dj'
  get '/schedule', to: 'visitors#schedule'
  get '/blog', to: 'visitors#blog'
  get '/blog_details', to: 'visitors#blog_details'
  get '/faq', to: 'visitors#faq'
  get '/contact_us', to: 'visitors#contact_us'
  get '/artist', to: 'artists#show'
  get '/store', to: 'visitors#store'
  get '/new_artist_upload', to: 'artists#new'
  get '/new_feature_upload', to: 'features#new'
  get '/downloads', to: 'artists#downloads'
  get '/new_music_upload', to: 'tracks#new'
  get '/new_gallery_upload', to: 'galleries#new'
  get '/admin_show', to: 'galleries#admin_show'
  get '/new_video_upload', to: 'videos#new'
  get '/all_videos', to: 'videos#all_videos'
  get '/new_store_upload', to: 'stores#new'
  get '/new_event_upload', to: 'events#new'
  get '/portfolio', to: 'visitors#portfolio'
  get '/new_banner_upload', to: 'main_banners#new'
  get '/admin_index', to: 'features#admin_index'
  get '/artist_songs', to: 'artists#artist'
  get '/banners_index', to: 'main_banners#index'
  get '/stage', to: 'visitors#stage'
  get '/coming_soon', to: 'coming_soon#index'
  get '/team', to: 'visitors#team'
  get '/new_lifestyle_upload', to: 'lifestyles#new'
  get '/lifestyle_admin_index', to: 'lifestyles#lifestyle_admin_index'
  get '/lifestyle', to: 'lifestyles#index'
  get '/admin_album_index', to: 'albums#admin_album_index'
  get 'index_old', to: 'visitors#index_old', as: 'visitors_old'
  
  
  # Renamed route for 'admin_show_album' to avoid conflict
  get '/admin_show_album/:id', to: 'albums#admin_show_album', as: :admin_show_album
  
  get '/admin_all_music', to: 'tracks#admin_all_music'
  get '/admin_artist_index', to: 'artists#admin_artist_index'
  get '/new_album_upload', to: 'albums#new'
  get '/admin', to: 'admins#index'
  get '/admins', to: 'galleries#new'
  get '/admin_all_events', to: 'events#admin_all_events', as: :admin_all_events
  get '/events_list_new_look', to: 'visitors#events_list_new_look'

  # Role-based dashboards
  get '/dashboard', to: 'dashboards#show', as: :dashboard
  get '/admin/dashboard', to: 'dashboards#admin', as: :admin_dashboard
  get '/member/dashboard', to: 'dashboards#member', as: :member_dashboard
  get '/dj/dashboard', to: 'dashboards#dj', as: :dj_dashboard
  get '/artist/dashboard', to: 'dashboards#artist', as: :artist_dashboard
  get '/photographer/dashboard', to: 'dashboards#photographer', as: :photographer_dashboard
  get '/videographer/dashboard', to: 'dashboards#videographer', as: :videographer_dashboard
  get '/curator/dashboard', to: 'dashboards#curator', as: :curator_dashboard
  get '/designer/dashboard', to: 'dashboards#designer', as: :designer_dashboard
  get '/editor/dashboard', to: 'dashboards#editor', as: :editor_dashboard

  # Impersonation routes (admin only)
  post '/impersonate/:id', to: 'impersonations#create', as: :impersonate
  delete '/stop_impersonating', to: 'impersonations#destroy', as: :stop_impersonating

  # Spree engine (ensure Spree is properly installed)
  #mount Spree::Core::Engine, at: '/mall'

  # Root path
  root 'visitors#index'
end
