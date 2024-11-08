Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :admin_users
  devise_for :users
  devise_for :admins

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
  resources :events

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
  get '/users', to: 'users#index'
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
  get '/admins', to: 'galleries#new'
  get '/admin_all_events', to: 'events#admin_all_events'

  # Spree engine (ensure Spree is properly installed)
  #mount Spree::Core::Engine, at: '/mall'

  # Root path
  root 'visitors#index'
end
