module RoleBasedAccess
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :check_backstage_access
  end

  private

  def check_backstage_access
    unless current_user&.can_access_backend?
      flash[:alert] = "You don't have permission to access this area."
      redirect_to root_path
    end
  end

  def require_admin
    unless current_user&.admin?
      flash[:alert] = "Admin access required."
      redirect_to root_path
    end
  end

  def require_dj
    unless current_user&.dj? || current_user&.admin?
      flash[:alert] = "DJ access required."
      redirect_to root_path
    end
  end

  def require_artist
    unless current_user&.artist? || current_user&.admin?
      flash[:alert] = "Artist access required."
      redirect_to root_path
    end
  end

  def require_dj_or_artist
    unless current_user&.dj? || current_user&.artist? || current_user&.admin?
      flash[:alert] = "DJ or Artist access required."
      redirect_to root_path
    end
  end

  def require_photographer
    unless current_user&.photographer? || current_user&.admin?
      flash[:alert] = "Photographer access required."
      redirect_to root_path
    end
  end

  def require_videographer
    unless current_user&.videographer? || current_user&.admin?
      flash[:alert] = "Videographer access required."
      redirect_to root_path
    end
  end

  def require_curator
    unless current_user&.curator? || current_user&.admin?
      flash[:alert] = "Curator access required."
      redirect_to root_path
    end
  end

  def require_designer
    unless current_user&.designer? || current_user&.admin?
      flash[:alert] = "Designer access required."
      redirect_to root_path
    end
  end

  def require_editor
    unless current_user&.editor? || current_user&.admin?
      flash[:alert] = "Editor access required."
      redirect_to root_path
    end
  end

  def require_content_creator
    unless current_user&.content_creator? || current_user&.admin?
      flash[:alert] = "Content creator access required."
      redirect_to root_path
    end
  end

  # Helper method to check if current user can access specific resource
  def can_access?(resource)
    return false unless current_user
    
    return true if current_user.admin?
    
    case resource
    when Track, Album
      current_user.artist? || current_user.dj? || current_user.curator? || current_user.editor?
    when Event
      current_user.dj? || current_user.curator? || current_user.editor?
    when Gallery, Image
      current_user.photographer? || current_user.curator? || current_user.editor?
    when Video
      current_user.videographer? || current_user.curator? || current_user.editor?
    when Feature
      current_user.curator? || current_user.editor?
    when MainBanner
      current_user.designer? || current_user.curator? || current_user.editor?
    else
      current_user.admin?
    end
  end
end

