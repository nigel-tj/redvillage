module DashboardHelper
  def dashboard_path_for_user(user = current_user)
    return root_path unless user
    
    case user.role
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
      root_path
    end
  end

  def role_badge_class(role)
    case role.to_s
    when 'admin'
      'bg-danger'
    when 'dj'
      'bg-info'
    when 'artist'
      'bg-success'
    when 'photographer'
      'bg-warning'
    when 'videographer'
      'bg-primary'
    when 'curator'
      'bg-purple'
    when 'designer'
      'bg-pink'
    when 'editor'
      'bg-dark'
    else
      'bg-secondary'
    end
  end

  def can_impersonate?(user)
    current_user&.admin? && user != current_user && user_signed_in?
  end
  
  def dashboard_path
    dashboard_path_for_user(current_user)
  end
end

