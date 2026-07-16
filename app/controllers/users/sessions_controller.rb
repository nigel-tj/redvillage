class Users::SessionsController < Devise::SessionsController
  layout "marketplace"

  before_action :configure_sign_in_params, only: [:create]

  def create
    super do |resource|
      session[:login_attempts] = 0
      session[:last_login] = Time.current if resource.present?
    end
  end

  private

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :remember_me])
  end

  def after_sign_in_path_for(resource)
    if session[:original_user_id].present?
      return admin_dashboard_path if resource.admin?
    end

    case resource.role
    when "admin"
      admin_dashboard_path
    when "dj"
      dj_dashboard_path
    when "artist"
      artist_dashboard_path
    when "photographer"
      photographer_dashboard_path
    when "videographer"
      videographer_dashboard_path
    when "curator"
      curator_dashboard_path
    when "designer"
      designer_dashboard_path
    when "editor"
      editor_dashboard_path
    else
      root_path
    end
  end
end
