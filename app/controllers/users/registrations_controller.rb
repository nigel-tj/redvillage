class Users::RegistrationsController < Devise::RegistrationsController
  layout "marketplace"

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def create
    super do |resource|
      session[:onboarding_complete] = true if resource.persisted?
    end
  end

  protected

  # Ignore any client-supplied role; public signup is always member.
  def build_resource(hash = nil)
    hash = (hash || {}).to_h.with_indifferent_access.except(:role)
    super(hash).tap { |user| user.role = :member }
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def configure_account_update_params
    # Never allow role changes via account update (privilege escalation).
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_up_path_for(resource)
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
    when "member"
      member_dashboard_path
    else
      ticket_listings_path
    end
  end
end
