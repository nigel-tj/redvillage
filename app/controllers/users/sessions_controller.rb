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
    if resource.admin?
      admin_path
    elsif session[:onboarding_complete] != true
      # First time users - could redirect to onboarding
      root_path
    else
      root_path
    end
  end
end
