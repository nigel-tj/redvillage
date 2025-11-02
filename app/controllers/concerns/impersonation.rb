module Impersonation
  extend ActiveSupport::Concern

  included do
    # Note: before_action is not set here as it should only apply to specific controllers
    # (ImpersonationsController already has require_admin)
    
    # Make these methods available as helpers in views
    helper_method :impersonating?, :original_user
  end

  # Helper methods available in all controllers that include this concern
  def impersonating?
    return false unless user_signed_in?
    session[:original_user_id].present? && current_user.id != session[:original_user_id].to_i
  end

  def original_user
    return nil unless impersonating?
    @original_user ||= User.find_by(id: session[:original_user_id])
  end
end

