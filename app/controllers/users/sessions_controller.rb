class Users::SessionsController < Devise::SessionsController
  layout "authentication"

  before_action :configure_sign_in_params, only: [:create]

  def new
    super
    # Track login attempts for analytics
    session[:login_attempts] ||= 0
  end

  def create
    super do |resource|
      # Reset login attempts on successful login
      session[:login_attempts] = 0
      
      # Track successful login
      if resource.present?
        session[:last_login] = Time.current
      end
    end
  end

  private

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :remember_me])
  end

  def after_sign_in_path_for(resource)
    # Check if we're returning from impersonation
    if session[:original_user_id].present?
      return admin_dashboard_path if resource.admin?
    end
    
    # Redirect based on user role
    case resource.role
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
      # Regular members go to public site
      if session[:onboarding_complete] != true
        # First time users - could redirect to onboarding
        root_path
      else
        root_path
      end
    end
  end
end
